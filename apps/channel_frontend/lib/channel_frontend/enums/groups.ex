defmodule ChannelFrontend.Enums.Groups do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Enums.Groups
  """

  @spec drop_type(atom) :: non_neg_integer
  def drop_type(:everyone), do: 0
  def drop_type(:group_members), do: 1
  def drop_type(:last_hitting), do: 2
  def drop_type(:random), do: 3
  def drop_type(:most_damages), do: 4
end
