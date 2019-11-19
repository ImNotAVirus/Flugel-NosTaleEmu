defmodule WorldServer.Enums.Game.Buffs do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Game.Buffs
  """

  @spec type(atom) :: non_neg_integer
  def type(:good), do: 0
  def type(:neutral), do: 1
  def type(:bad), do: 2
end
