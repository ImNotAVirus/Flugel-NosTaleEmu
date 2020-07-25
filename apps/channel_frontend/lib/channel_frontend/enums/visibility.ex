defmodule ChannelFrontend.Enums.Visibility do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Enums.Visibility
  """

  @spec type(atom) :: non_neg_integer
  def type(:invisible), do: 0
  def type(:visible), do: 1
end
