defmodule WorldServer.Packets.Player.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.Player.Views
  """

  use ElvenGard.View

  alias WorldServer.Structures.Character
  alias WorldServer.Enums.Character, as: EnumChar

  @spec render(atom, term) :: String.t()
  def render(:tit, %Character{} = character) do
    %Character{class: class, name: name} = character
    "tit #{EnumChar.class_str(class)} #{name}"
  end

  def render(:c_info, %Character{} = character) do
    %Character{
      id: id,
      name: name,
      class: class,
      gender: gender,
      hair_style: hair_style,
      hair_color: hair_color
    } = character

    group_id = -1
    family_id = 1
    family_name = "Alchemists"
    name_color = EnumChar.name_appearance(:game_master)
    reputation_icon = EnumChar.reputation(:legendary_heros)
    compliment = 0
    morph = 0
    invisible = false
    family_level = 20
    sp_upgrade = 0
    arena_winner = 0

    invisible_int = if invisible, do: 1, else: 0

    "c_info #{name} - #{group_id} #{family_id} #{family_name} #{id} #{name_color} #{gender}" <>
      " #{hair_style} #{hair_color} #{class} #{reputation_icon} #{compliment} #{morph} " <>
      "#{invisible_int} #{family_level} #{sp_upgrade} #{arena_winner}"
  end
end
