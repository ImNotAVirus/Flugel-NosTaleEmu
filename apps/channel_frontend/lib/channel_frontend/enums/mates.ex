defmodule ChannelFrontend.Enums.Mates do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Enums.Mates
  """

  @spec sp_partner_rank(atom) :: non_neg_integer
  def sp_partner_rank(:not_identified_yet), do: 0
  def sp_partner_rank(:f), do: 1
  def sp_partner_rank(:e), do: 2
  def sp_partner_rank(:d), do: 3
  def sp_partner_rank(:c), do: 4
  def sp_partner_rank(:b), do: 5
  def sp_partner_rank(:a), do: 6
  def sp_partner_rank(:s), do: 7
end
