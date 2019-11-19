defmodule WorldServer.Enums.Game.Upgrade do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Game.Upgrade
  """

  @spec fixed_up_mode_type(atom) :: non_neg_integer
  def fixed_up_mode_type(:none), do: 0
  def fixed_up_mode_type(:has_amulet), do: 1

  @spec rarify_mode_type(atom) :: non_neg_integer
  def rarify_mode_type(:normal), do: 0
  def rarify_mode_type(:free), do: 1
  def rarify_mode_type(:drop), do: 2
  def rarify_mode_type(:success), do: 3
  def rarify_mode_type(:reduce), do: 4

  @spec rarify_protection_type(atom) :: non_neg_integer
  def rarify_protection_type(:none), do: 0
  def rarify_protection_type(:blue_amulet), do: 1
  def rarify_protection_type(:red_amulet), do: 2
  def rarify_protection_type(:heroic_amulet), do: 3
  def rarify_protection_type(:random_heroic_amulet), do: 4
  def rarify_protection_type(:reduce_heroic_amulet), do: 5
  def rarify_protection_type(:scroll), do: 6

  @spec mode_type(atom) :: non_neg_integer
  def mode_type(:normal), do: 0
  def mode_type(:reduced), do: 1
  def mode_type(:free), do: 2

  @spec protection_type(atom) :: non_neg_integer
  def protection_type(:none), do: 0
  def protection_type(:protected), do: 1

  @spec type_event(atom) :: non_neg_integer
  def type_event(:item), do: 0
  def type_event(:specialist), do: 1
end
