defmodule LoginServer.PacketHandler do
  @moduledoc """
  Received packet handler.
  """

  use ElvenGard.Packet

  alias LoginServer.Auth.Actions
  alias LoginServer.Types

  @desc """
  The login packet

  TODO: Would be cool to have a custom field "password_field" to decryt pass
  """
  packet "NoS0575" do
    @desc "I thinks it's a session_id but is it really usefull ?"
    field :session, :integer

    field :username, :string

    @desc "Encrypted for NostaleSE and in SHA512 for others"
    field :password, Types.Password

    @desc "A random string like `0039E3DC`. I don't known what it is"
    field :unknown, :string

    @desc "Something like `0.9.3.3071`"
    field :version, :string

    resolve &Actions.player_connect/3
  end

  default_packet do
    Logger.warn("Unknown packet header #{inspect(packet_name)} with args: #{inspect(args)}")
    {:halt, {:error, :unknown_header}, client}
  end
end
