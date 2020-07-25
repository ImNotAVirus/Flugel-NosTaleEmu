defmodule ChannelFrontend.Enums.Portals do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Enums.Portals
  """

  @spec type(atom) :: integer
  def type(:map_portal), do: -1
  # same over >127 - sbyte
  def type(:ts_normal), do: 0
  def type(:closed), do: 1
  def type(:open), do: 2
  def type(:miniland), do: 3
  def type(:ts_end), do: 4
  def type(:ts_end_closed), do: 5
  def type(:exit), do: 6
  def type(:exit_closed), do: 7
  def type(:raid), do: 8
  # same as 13 - 19 and 20 - 126
  def type(:effect), do: 9
  def type(:blue_raid), do: 10
  def type(:dark_raid), do: 11
  def type(:time_space), do: 12
  def type(:shop_teleport), do: 20
end
