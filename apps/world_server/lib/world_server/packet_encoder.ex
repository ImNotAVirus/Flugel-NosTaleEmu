defmodule WorldServer.PacketEncoder do
  @moduledoc """
  Parse a World packet
  """

  use ElvenGard.PacketEncoders.TextualEncoder,
    model: WorldServer.PacketHandler,
    separator: " "

  require Logger

  alias ElvenGard.Structures.Client
  alias WorldServer.Crypto

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
    session_id = Client.get_metadata(client, :session_id)
    {auth_step, data, session_id}
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
  def decode({:waiting_session, data, nil}) do
    # Place fake packet header
    {"session_id", Crypto.decrypt_session(data)}
  end

  @impl true
  def decode({:waiting_username, data, session_id}) do
    data = Crypto.decrypt(data, session_id, true)

    case data do
      [{_last_live, username}] ->
        # Place fake packet header
        {"username", username}

      [{_last_live, username}, {_last_live2, password}] ->
        # Place fake packet header
        [{"username", username}, {"password", password}]
    end
  end

  @impl true
  def decode({:waiting_password, data, session_id}) do
    [{_last_live, password}] = Crypto.decrypt(data, session_id, true)

    # Place fake packet header
    {"password", password}
  end

  @doc false
  @spec normalize_list(list) :: list
  defp normalize_list([x]), do: [x, ""]
  defp normalize_list([_ | _] = x), do: x
end
