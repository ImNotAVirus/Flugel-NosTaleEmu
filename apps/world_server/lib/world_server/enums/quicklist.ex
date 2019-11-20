defmodule WorldServer.Enums.Quicklist do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Quicklist
  """

  @spec item_slot_type(atom) :: non_neg_integer
  def item_slot_type(:equipment), do: 0
  def item_slot_type(:main), do: 1
  def item_slot_type(:etc), do: 2

  @spec skill_slot_type(atom) :: non_neg_integer
  def skill_slot_type(:formation), do: 1
  def skill_slot_type(:skills), do: 2
  def skill_slot_type(:motion), do: 3
end
