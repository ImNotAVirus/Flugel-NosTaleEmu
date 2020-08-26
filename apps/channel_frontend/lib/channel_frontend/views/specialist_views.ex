defmodule ChannelFrontend.SpecialistViews do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.SpecialistViews
  """

  use ElvenGard.View

  import ChannelCaching.Character, only: [character: 2, is_character: 1]

  @spec render(atom(), any()) :: String.t()
  def render(:sp, char_record) when is_character(char_record) do
    points = character(char_record, :sp_points)
    additional_points = character(char_record, :sp_additional_points)
    points_max = character(char_record, :sp_points_max)
    additional_points_max = character(char_record, :sp_additional_points_max)

    "sp #{additional_points} #{additional_points_max} #{points} #{points_max}"
  end
end
