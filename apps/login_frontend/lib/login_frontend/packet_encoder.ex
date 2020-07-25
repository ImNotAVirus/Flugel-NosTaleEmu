defmodule LoginFrontend.PacketEncoder do
  @moduledoc """
  Encode and decode a Login packet
  """

  use ElvenGard.Protocol.Textual,
    model: LoginFrontend.PacketHandler,
    separator: [" ", "\v"]

  require Logger

  alias LoginFrontend.Crypto

  @impl true
  @spec encode(String.t()) :: binary
  def encode(data) do
    Crypto.encrypt(data)
  end

  @impl true
  @spec decode(binary) :: {term, map}
  def decode(data) do
    data
    |> Crypto.decrypt()
    |> String.replace("\n", "")
    |> String.split(" ", parts: 2)
    |> List.to_tuple()
  end
end
