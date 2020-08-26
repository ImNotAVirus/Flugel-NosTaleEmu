defmodule ChannelFrontend.EntityViews do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.EntityViews
  """

  use ElvenGard.View

  import ChannelCaching.Character, only: [character: 2, is_character: 1]

  alias ChannelFrontend.Enums.Entity, as: EnumsEntity
  alias Core.PacketHelpers

  @spec render(atom(), any()) :: String.t()
  def render(:stat, char_record) when is_character(char_record) do
    hp = character(char_record, :hp)
    hp_max = character(char_record, :hp_max)
    mp = character(char_record, :mp)
    mp_max = character(char_record, :mp_max)

    "stat #{hp} #{hp_max} #{mp} #{mp_max} 0 0"
  end

  # TODO: Later, add clauses for mobs, npc, mates, ...
  def render(:eff, %{target: char_record, value: value}) when is_character(char_record) do
    character_id = character(char_record, :id)
    entity_type = EnumsEntity.type(:character)

    "eff #{entity_type} #{character_id} #{value}"
  end

  # TODO: Later, add clauses for mobs, npc, mates, ...
  def render(:cond, char_record) when is_character(char_record) do
    character_id = character(char_record, :id)
    no_attack = character(char_record, :no_attack)
    no_move = character(char_record, :no_move)
    speed = character(char_record, :speed)

    entity_type = EnumsEntity.type(:character)
    no_attack_str = PacketHelpers.serialize_boolean(no_attack)
    no_move_str = PacketHelpers.serialize_boolean(no_move)

    "cond #{entity_type} #{character_id} #{no_attack_str} #{no_move_str} #{speed}"
  end

  # TODO: Later, add clauses for mobs, npc, mates, ...
  def render(:pairy, char_record) when is_character(char_record) do
    character_id = character(char_record, :id)
    entity_type = EnumsEntity.type(:character)

    # TODO: Get fairy from InventoryService
    fairy_move_type = 1
    element = EnumsEntity.element_type(:darkness)
    element_rate = 255
    morph = 13

    "pairy #{entity_type} #{character_id} #{fairy_move_type} #{element} #{element_rate} #{morph}"
  end
end
