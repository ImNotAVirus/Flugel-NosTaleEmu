defmodule WorldServer.PacketHandler do
  @moduledoc """
  Received packet handler.
  """

  use ElvenGard.Packet

  import WorldServer.Enums.Packets.Guri, only: [guri_type: 1]

  alias WorldServer.Packets.Authentication.Actions, as: AuthenticationActions
  alias WorldServer.Packets.CharacterLobby.Actions, as: CharacterLobbyActions
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

  ## Authentication part

  @desc """
  First packet sent by a client.
  Nedded for decrypt all following packets.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "encryption_key" do
    field :encryption_key, :integer
    resolve &AuthenticationActions.process_encryption_key/3
  end

  @desc """
  On the new protocol, this packet replace the `username` packet.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "session_id" do
    field :session_id, :integer
    resolve &AuthenticationActions.process_session_id/3
  end

  @desc """
  Third packet send by a client.
  Contains only his password in plain text.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "password" do
    field :password, :string
    resolve &AuthenticationActions.verify_session/3
  end

  ## Character management

  @desc """
  Ask for a character creation

  Example: `Char_NEW TestChar 0 1 1 2`
  """
  packet "Char_NEW" do
    field :name, :string
    field :slot, :integer
    field :gender, :integer, desc: "Enum: GenderType"
    field :hair_style, :integer, desc: "Enum: HairStyle"
    field :hair_color, :integer, desc: "Enum: HairColor"

    resolve &CharacterLobbyActions.create_character/3
  end

  @desc """
  Ask for a character suppression

  Example: `Char_DEL 3 password`
  """
  packet "Char_DEL" do
    field :slot, :integer
    field :password, :string

    resolve &CharacterLobbyActions.delete_character/3
  end

  ## Character selection

  @desc """
  Select a character
  """
  packet "select" do
    field :character_slot, :integer
    resolve &CharacterLobbyActions.select_character/3
  end

  @desc """
  Character will enter on the game
  """
  packet "game_start" do
    resolve &PlayerActions.game_start/3
  end

  ## Others packets

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :type, :integer, using: guri_type(:emoji)
    field :unknown, :integer
    field :entity_id, :integer
    field :value, :integer
    resolve &UIActions.show_emoji/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act1)
    resolve &UIActions.show_scene/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act2)
    resolve &UIActions.show_scene/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act3)
    resolve &UIActions.show_scene/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act4)
    resolve &UIActions.show_scene/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act5)
    resolve &UIActions.show_scene/3
  end
end
