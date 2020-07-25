defmodule ChannelFrontend.Packets.CharacterLobby.Views do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Packets.CharacterLobby.Views
  """

  use ElvenGard.View

  alias DatabaseService.Player.Character
  alias ChannelFrontend.Enums.Character, as: EnumChar

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

    # TODO: Get it from InventoryService
    equipments = ["-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1"]
    # TODO: Get it from MateService
    pets = []

    design = 0
    quest_completion = 1
    quest_part = 1

    petlist = serialize_list(pets)
    equipmentlist = serialize_list(equipments)
    gender_int = EnumChar.gender_type(gender)
    hair_style_int = EnumChar.hair_style_type(hair_style)
    hair_color_int = EnumChar.hair_color_type(hair_color)
    class_int = EnumChar.class_type(class)

    "clist #{slot} #{name} 0 #{gender_int} #{hair_style_int} #{hair_color_int} 0 #{class_int}" <>
      " #{level} #{hero_level} #{equipmentlist} #{job_level} #{quest_completion} " <>
      "#{quest_part} #{petlist} #{design}"
  end

  #
  # Helper function
  # TODO: Move it inside 'Core' app
  #

  @spec serialize_list([term, ...], String.t()) :: String.t()
  defp serialize_list(enumerable, joiner \\ ".")
  defp serialize_list([], _), do: "-1"
  defp serialize_list([_ | _] = enumerable, joiner), do: Enum.join(enumerable, joiner)
end
