defmodule WorldServer.PacketHandler do
  @moduledoc """
  Received packet handler.
  """

  use ElvenGard.Packet

  alias WorldServer.Packets.CharacterSelection.Actions, as: CharSelectActions
  alias WorldServer.Packets.Player.Actions, as: PlayerActions
  alias WorldServer.Packets.UserInterface.Actions, as: UIActions

  #
  # Useless packets
  #

  @desc "Maybe a keep alive packet ?"
  useless_packet "0"

  useless_packet "c_close"
  useless_packet "f_stash_end"
  useless_packet "lbs"

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
    resolve &CharSelectActions.process_session_id/3
  end

  @desc """
  Second packet send by a client.
  Contains only his username.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "username" do
    field :username, :string
    resolve &CharSelectActions.process_username/3
  end

  @desc """
  Third packet send by a client.
  Contains only his password in plain text.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "password" do
    field :password, :string
    resolve &CharSelectActions.verify_session/3
  end

  @desc """
  Select a character
  """
  packet "select" do
    field :character_slot, :integer
    resolve &CharSelectActions.select_character/3
  end

  @desc """
  Character will enter on the game
  """
  packet "game_start" do
    resolve &PlayerActions.game_start/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :type, :integer
    field :unknown, :integer
    field :entity_id, :integer
    field :value, :integer
    resolve &UIActions.guri_handler/3
  end
end
