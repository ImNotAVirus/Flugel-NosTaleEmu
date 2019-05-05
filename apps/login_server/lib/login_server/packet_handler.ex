defmodule LoginServer.PacketHandler do
  @moduledoc """
  Received packet handler.
  """

  use ElvenGard.Helpers.Packet

  alias LoginServer.Actions.Auth
  alias ElvenGard.Types.Textual.{IntegerType, StringType}

  @desc """
  The login packet

  TODO: Would be cool to have a custom field "password_field" to decryt pass
  """
  packet "NoS0575" do
    @desc "I thinks it's a session_id but is it really usefull ?"
    field :session, IntegerType

    field :username, StringType

    @desc "Crypted for NostaleSE and in SHA512 for others"
    # field :password, :password_field
    field :password, StringType

    @desc "A random string like `0039E3DC`. I don't known what it is"
    field :unknown, StringType

    @desc "Something like `0.9.3.3071`"
    field :version, StringType

    resolve &Auth.player_connect/3
  end

  default_packet do
    Logger.warn("Unknown packet header #{inspect(packet_name)} with args: #{inspect(args)}")
    {:halt, {:error, :unknown_header}, client}
  end
end
