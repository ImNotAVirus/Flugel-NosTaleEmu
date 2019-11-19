defmodule WorldServer.Enums.Game.Skill do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Game.Skill
  """

  @spec target_type(atom) :: non_neg_integer
  def target_type(:single_hit), do: 0
  def target_type(:aoe), do: 1
  def target_type(:single_buff), do: 2
end
