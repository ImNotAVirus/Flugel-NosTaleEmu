defmodule WorldServer.Enums.Game.Drop do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Game.Drop
  """

  @spec type(atom) :: non_neg_integer
  def type(:npc_monster), do: 0
  def type(:map_type), do: 1
  def type(:global), do: 2
end
