defmodule WorldServer.Packets.CharacterSelection.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.CharacterSelection.Views
  """

  use ElvenGard.View

  alias WorldServer.Structures.Character

  @spec render(atom, term) :: String.t()
  def render(:ok, _) do
    "OK"
  end

  def render(:clist_start, _) do
    "clist_start 0"
  end

  def render(:clist_end, _) do
    "clist_end"
  end

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

    "clist #{slot} #{name} 0 #{gender} #{hair_style} #{hair_color} 0 #{class}" <>
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
