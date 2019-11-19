defmodule WorldServer.Enums.Game.Entity do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Game.Entity
  """

  @spec direction_type(atom) :: non_neg_integer
  def direction_type(:north), do: 0
  def direction_type(:east), do: 1
  def direction_type(:south), do: 2
  def direction_type(:west), do: 3
  def direction_type(:north_east), do: 4
  def direction_type(:south_east), do: 5
  def direction_type(:south_west), do: 6
  def direction_type(:north_west), do: 7

  @spec element_type(atom) :: non_neg_integer
  def element_type(:neutral), do: 0
  def element_type(:fire), do: 1
  def element_type(:water), do: 2
  def element_type(:light), do: 3
  def element_type(:dark), do: 4

  @spec mate_type(atom) :: non_neg_integer
  def mate_type(:partner), do: 0
  def mate_type(:pet), do: 1

  @spec monster_type(atom) :: non_neg_integer
  def monster_type(:unknown), do: 0
  def monster_type(:partner), do: 1
  def monster_type(:npc), do: 2
  def monster_type(:well), do: 3
  def monster_type(:portal), do: 4
  def monster_type(:boss), do: 5
  def monster_type(:elite), do: 6
  def monster_type(:peapod), do: 7
  def monster_type(:special), do: 8
  def monster_type(:gem_space_time), do: 9

  @spec npc_monster_race_type(atom) :: non_neg_integer
  def npc_monster_race_type(:race0_unknown_yet), do: 0
  def npc_monster_race_type(:race1), do: 1

  @spec req_info_type(atom) :: non_neg_integer
  def req_info_type(:item_info), do: 12
  def req_info_type(:mate_info), do: 6
  def req_info_type(:npc_info), do: 5

  @spec visual_type(atom) :: non_neg_integer
  def visual_type(:character), do: 1
  def visual_type(:npc), do: 2
  def visual_type(:monster), do: 3
  def visual_type(:map_object), do: 9
  # unknown yet
  def visual_type(:portal), do: 1000
end
