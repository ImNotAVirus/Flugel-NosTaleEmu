defmodule ChannelMap.Views do
  @moduledoc """
  TODO: Documentation for ChannelMap.Views
  """

  use ElvenGard.View

  import ChannelCaching.Character, only: [character: 2, is_character: 1]

  @spec render(atom(), any()) :: String.t()
  def render(:at, %{target: char_record, state: %{id: map_id, music: map_music}})
      when is_character(char_record) do
    character_id = character(char_record, :id)
    map_x = character(char_record, :map_x)
    map_y = character(char_record, :map_y)

    "at #{character_id} #{map_id} #{map_x} #{map_y} 2 0 #{map_music} -1"
  end

  def render(:c_map, %{id: map_id, type: map_type}) do
    "c_map 0 #{map_id} #{map_type}"
  end
end
