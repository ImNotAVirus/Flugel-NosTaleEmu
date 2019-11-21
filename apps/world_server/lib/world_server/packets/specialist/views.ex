defmodule WorldServer.Packets.Specialist.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.Specialist.Views
  """

  use ElvenGard.View

  @spec render(atom, term) :: String.t()
  def render(:sp, attrs) do
    %{
      points: points,
      additional_points: additional_points
    } = attrs

    # Get it from conf files
    max_additional_points = 500_000
    max_daily_points = 10_000

    "sp #{additional_points} #{max_additional_points} #{points} #{max_daily_points}"
  end
end
