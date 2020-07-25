defmodule ChannelFrontend.Enums.Packets.Say do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Enums.Packets.Say
  """

  @spec color_type(atom) :: integer
  def color_type(:white), do: -1
  def color_type(:default), do: 0
  def color_type(:group), do: 3
  def color_type(:grey), do: 4
  def color_type(:whisper_name), do: 5
  def color_type(:family), do: 6
  def color_type(:light_yellow), do: 7
  def color_type(:whisper), do: 8
  def color_type(:special_gold), do: 10
  def color_type(:special_red), do: 11
  def color_type(:special_green), do: 12
  def color_type(:special_grey), do: 13
  def color_type(:effect_bar), do: 20
end
