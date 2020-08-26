defmodule ChannelFrontend.MiniMapViews do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.MiniMapViews
  """

  use ElvenGard.View

  import ChannelCaching.Character, only: [character: 2, is_character: 1]

  alias Core.PacketHelpers

  @spec render(atom(), any()) :: String.t()
  def render(:at, char_record) when is_character(char_record) do
    character_id = character(char_record, :id)
    map_id = character(char_record, :map_id)
    map_x = character(char_record, :map_x)
    map_y = character(char_record, :map_y)

    # TODO: Get map music from MapManager
    map_music = 1

    "at #{character_id} #{map_id} #{map_x} #{map_y} 2 0 #{map_music} -1"
  end

  def render(:c_map, char_record) when is_character(char_record) do
    map_id = character(char_record, :map_id)

    # 1 = base & 0 = instanciated ?
    map_type =
      char_record
      |> character(:map_instance_ref)
      |> Kernel.==(nil)
      |> PacketHelpers.serialize_boolean()

    "c_map 0 #{map_id} #{map_type}"
  end
end
