defmodule WorldServer.Enums.Nosbazaar do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Nosbazaar
  """

  @spec category_type(atom) :: non_neg_integer
  def category_type(:all), do: 0
  def category_type(:weapon), do: 1
  def category_type(:armor), do: 2
  def category_type(:equipements), do: 3
  def category_type(:jewels), do: 4
  def category_type(:specialists), do: 5
  def category_type(:pets), do: 6
  def category_type(:pets_pearls), do: 7
  def category_type(:locomotion), do: 8
  def category_type(:shell), do: 9
  def category_type(:main_objects), do: 10
  def category_type(:consumable_objects), do: 11
  def category_type(:others), do: 12

  @spec order_type(atom) :: non_neg_integer
  def order_type(:price_ascending), do: 0
  def order_type(:price_descending), do: 1
  def order_type(:quantity_ascending), do: 2
  def order_type(:quantity_descending), do: 3
end
