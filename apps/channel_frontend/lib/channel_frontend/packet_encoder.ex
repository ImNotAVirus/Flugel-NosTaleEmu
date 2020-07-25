defmodule ChannelFrontend.PacketEncoder do
  @moduledoc """
  Parse a World packet
  """

  use ElvenGard.Protocol.Textual,
    model: ChannelFrontend.PacketHandler,
    separator: " "

  require Logger

  alias ElvenGard.Structures.Client
  alias ChannelFrontend.Crypto

  #
  # Encode callback
  #

  @impl true
  @spec encode(String.t()) :: binary
  def encode(data) do
    Crypto.encrypt(data)
  end

  #
  # Decode callbacks
  #

  @impl true
  def pre_decode(data, %Client{} = client) do
    auth_step = Client.get_metadata(client, :auth_step)
    encryption_key = Client.get_metadata(client, :encryption_key)
    {auth_step, data, encryption_key}
  end

  @impl true
  @spec decode(
          {:done, binary, integer}
          | {:waiting_session, binary, nil}
          | {:waiting_password, binary, integer}
          | {:waiting_username, binary, integer}
        ) :: {term, map} | list({term, map})
  def decode({:done, data, session_id}) do
    data
    |> Crypto.decrypt(session_id, true)
    |> Stream.map(fn {_last_live, packet} -> packet end)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " ", parts: 2))
    |> Stream.map(&normalize_list/1)
    |> Enum.map(&List.to_tuple/1)
  end

  @impl true
  def decode({:waiting_encryption_key, data, nil}) do
    {"encryption_key", Crypto.decrypt_session(data)}
  end

  @impl true
  def decode({:waiting_session, data, encryption_key}) do
    case Crypto.decrypt(data, encryption_key, true) do
      [{_last_live, session_id}] ->
        # Place fake packet header
        {"session_id", session_id}

      [{_last_live, session_id}, {_last_live2, password}] ->
        # Place fake packet header
        [{"session_id", session_id}, {"password", password}]
    end
  end

  @impl true
  def decode({:waiting_password, data, encryption_key}) do
    [{_last_live, password}] = Crypto.decrypt(data, encryption_key, true)

    # Place fake packet header
    {"password", password}
  end

  ## Private functions

  @doc false
  @spec normalize_list(list) :: list
  defp normalize_list([x]), do: [x, ""]
  defp normalize_list([_ | _] = x), do: x
end
