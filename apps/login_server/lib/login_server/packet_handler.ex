defmodule LoginServer.PacketHandler do
  @moduledoc """
  Received packet handler.
  """

  use ElvenGard.Packet

  alias LoginServer.Auth.Actions
  alias LoginServer.Types

  # @desc """
  # The login packet (NostaleSE version)

  # Example: "NoS0575 6799404 admin 4126414674161D56B9367E 00913DCD\v0.9.3.3086"
  # """
  # packet "NoS0575" do
  #   field :session, :integer, desc: "I thinks it's a session_id but is it really usefull ?"
  #   field :username, :string
  #   field :password, Types.Password, desc: "Encrypted for NostaleSE and in SHA512 for others"
  #   field :unknown, :string
  #   field :version, :string, desc: "Client version"

  #   resolve &Actions.player_connect_se/3
  # end

  @desc """
  The login packet (GameForge old version)

  Example: "NoS0575 4745632 admin [sha512_hash] 0047BA11\v0.9.3.3086 0 [md5_hash]"
  """
  packet "NoS0575" do
    field :session, :integer, desc: "I thinks it's a session_id but is it really usefull ?"
    field :username, :string
    field :password, :string
    field :unknown, :string
    field :version, :string, desc: "Client version"
    field :unknown2, :string, using: "0"
    field :checksum, :string, desc: "Client hash: md5(NostaleClientX.exe + NostaleClient.exe)"

    resolve &Actions.player_connect_gf_old/3
  end

  default_packet do
    Logger.warn("Unknown packet header #{inspect(packet_name)} with args: #{inspect(args)}")
    {:halt, {:error, :unknown_header}, client}
  end
end
