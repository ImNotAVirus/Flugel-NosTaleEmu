defmodule ChannelLobby.Views do
  @moduledoc """
  TODO: Documentation for ChannelLobby.Views
  """

  use ElvenGard.View

  alias Core.{CharacterEnums, PacketHelpers}
  alias DatabaseService.Player.Character

  @spec render(atom(), any()) :: String.t()
  def render(:ok, _), do: "OK"
  def render(:clist_start, _), do: "clist_start 0"
  def render(:clist_end, _), do: "clist_end"
  def render(:success, _), do: "success"
  def render(:name_already_used, _), do: "infoi 875 0 0 0"
  def render(:creation_failed, _), do: "infoi 876 0 0 0"
  def render(:invalid_password, _), do: "infoi 360 0 0 0"
  def render(:invalid_select_slot, _), do: "info INVALID_CHARACTER_SLOT"

  def render(:clist, %Character{} = character) do
    %Character{
      slot: slot,
      name: name,
      gender: gender,
      hair_style: hair_style,
      hair_color: hair_color,
      class: class,
      level: level,
      hero_level: hero_level,
      job_level: job_level
    } = character

    # TODO: Get it from DB
    equipments = ["-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1"]
    # TODO: Get it from DB
    pets = []

    design = 0
    quest_completion = 1
    quest_part = 1

    petlist = PacketHelpers.serialize_list(pets)
    equipmentlist = PacketHelpers.serialize_list(equipments)
    gender_int = CharacterEnums.gender(gender)
    hair_style_int = CharacterEnums.hair_style(hair_style)
    hair_color_int = CharacterEnums.hair_color(hair_color)
    class_int = CharacterEnums.class(class)

    "clist #{slot} #{name} 0 #{gender_int} #{hair_style_int} #{hair_color_int} 0 #{class_int}" <>
      " #{level} #{hero_level} #{equipmentlist} #{job_level} #{quest_completion} " <>
      "#{quest_part} #{petlist} #{design}"
  end
end
