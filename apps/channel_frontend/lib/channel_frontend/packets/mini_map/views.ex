defmodule ChannelFrontend.Packets.MiniMap.Views do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Packets.MiniMap.Views
  """

  use ElvenGard.View

  alias ChannelFrontend.Structures.Character

  @spec render(atom, term) :: String.t()
  def render(:at, %Character{} = character) do
    %Character{
      id: id
    } = character

    # TODO: Get position from MovingService
    map_id = 1
    pos_x = 40
    pos_y = 60

    # TODO: Get map music from MapManager
    map_music = 1

    "at #{id} #{map_id} #{pos_x} #{pos_y} 2 0 #{map_music} -1"
  end

  def render(:c_map, %Character{} = character) do
    %Character{
      id: _id
    } = character

    # TODO: Get position from MovingService
    map_id = 1

    # TODO: Get map type from MapManager
    #   (1 = base & 0 = instanciated ?)
    map_type = 1

    "c_map 0 #{map_id} #{map_type}"
  end
end
