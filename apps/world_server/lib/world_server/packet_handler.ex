defmodule WorldServer.PacketHandler do
  @moduledoc """
  Received packet handler.
  """

  use ElvenGard.Packet

  alias WorldServer.Packets.CharacterSelection.Actions

  #
  # Useless packets
  #

  @desc "Maybe a keep alive packet ?"
  useless_packet "0"

  useless_packet "c_close"
  useless_packet "f_stash_end"

  #
  # Usefull packets
  #

  @desc """
  First packet send by a client.
  Nedded for decrypt all following packets.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "session_id" do
    field :session_id, :integer
    resolve &Actions.process_session_id/3
  end

  @desc """
  Second packet send by a client.
  Contains only his username.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "username" do
    field :username, :string
    resolve &Actions.process_username/3
  end

  @desc """
  Third packet send by a client.
  Contains only his password in plain text.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "password" do
    field :password, :string
    resolve &Actions.verify_session/3
  end
end
