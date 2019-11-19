defmodule WorldServer.Enums.Game.Visibility do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Game.Visibility
  """

  @spec type(atom) :: non_neg_integer
  def type(:invisible), do: 0
  def type(:visible), do: 1
end
