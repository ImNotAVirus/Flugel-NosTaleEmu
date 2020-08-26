defmodule ChannelFrontend.PacketHandler do
  @moduledoc """
  Received packet handler.
  """

  use ElvenGard.Packet

  import ChannelFrontend.Enums.Packets.Guri, only: [guri_type: 1]

  alias ChannelFrontend.{PlayerActions, UserInterfaceActions}

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
    resolve &__MODULE__.call_to_service/3
  end

  @desc """
  On the new protocol, this packet replace the `username` packet.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "session_id" do
    field :session_id, :integer
    resolve &__MODULE__.call_to_service/3
  end

  @desc """
  Third packet send by a client.
  Contains only his password in plain text.

  /!\\ This packet doesn't have any packet header. Here, it's faked by Protocol
  """
  packet "password" do
    field :password, :string
    resolve &__MODULE__.call_to_service/3
  end

  ## Lobby packets

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

    resolve &__MODULE__.call_to_service/3
  end

  @desc """
  Ask for a character suppression

  Example: `Char_DEL 3 password`
  """
  packet "Char_DEL" do
    field :slot, :integer
    field :password, :string

    resolve &__MODULE__.call_to_service/3
  end

  @desc """
  Select a character
  """
  packet "select" do
    field :slot, :integer
    resolve &__MODULE__.call_to_service/3
  end

  ## Area Manager

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
    resolve &UserInterfaceActions.show_emoji/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act1)
    resolve &UserInterfaceActions.show_scene/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act2)
    resolve &UserInterfaceActions.show_scene/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act3)
    resolve &UserInterfaceActions.show_scene/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act4)
    resolve &UserInterfaceActions.show_scene/3
  end

  @desc """
  TODO: Description for this packet
  """
  packet "guri" do
    field :scene_id, :integer, using: guri_type(:scene_req_act5)
    resolve &UserInterfaceActions.show_scene/3
  end

  ## Helpers
  ## TODO: Rewrite that part

  @auth_headers ["encryption_key", "session_id", "password"]
  @lobby_headers ["Char_NEW", "Char_DEL", "select"]

  @doc false
  def call_to_service(client, header, params) when header in @auth_headers do
    {:ok, new_client} = ChannelAuth.call(header, params, client)
    {:cont, new_client}
  end

  def call_to_service(client, header, params) when header in @lobby_headers do
    {:ok, new_client} = ChannelLobby.call(header, params, client)
    {:cont, new_client}
  end
end
