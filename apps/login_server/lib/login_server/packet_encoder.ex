defmodule LoginServer.PacketEncoder do
  @moduledoc """
  Encode and decode a Login packet
  """

  use ElvenGard.PacketEncoder.TextualEncoder,
    model: LoginServer.PacketHandler,
    separator: [" ", "\v"]

  require Logger

  alias LoginServer.Crypto

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
