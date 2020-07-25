defmodule ChannelFrontend.Enums.Families do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Enums.Families
  """

  @spec authority(atom) :: non_neg_integer
  def authority(:head), do: 0
  def authority(:assistant), do: 1
  def authority(:manager), do: 2
  def authority(:member), do: 3

  @spec authority_type(atom) :: non_neg_integer
  def authority_type(:none), do: 0
  def authority_type(:put), do: 1
  def authority_type(:all), do: 2

  @spec log_type(atom) :: non_neg_integer
  def log_type(:daily_message), do: 1
  def log_type(:character_raid_won), do: 2
  def log_type(:rainbow_battle), do: 3
  def log_type(:family_xp_won), do: 4
  def log_type(:family_level_up), do: 5
  def log_type(:character_level_up), do: 6
  def log_type(:character_item_upgraded), do: 7
  def log_type(:right_changed), do: 8
  def log_type(:authority_changed), do: 9
  def log_type(:family_managed), do: 10
  def log_type(:user_managed), do: 11
  def log_type(:ware_house_added), do: 12
  def log_type(:ware_house_removed), do: 13

  @spec member_rank(atom) :: non_neg_integer
  def member_rank(:nothing), do: 0
  def member_rank(:old_uncle), do: 1
  def member_rank(:old_aunt), do: 2
  def member_rank(:father), do: 3
  def member_rank(:mother), do: 4
  def member_rank(:uncle), do: 5
  def member_rank(:aunt), do: 6
  def member_rank(:brother), do: 7
  def member_rank(:sister), do: 8
  def member_rank(:spouse), do: 9
  def member_rank(:brother2), do: 10
  def member_rank(:sister2), do: 11
  def member_rank(:old_son), do: 12
  def member_rank(:old_daugter), do: 13
  def member_rank(:middle_son), do: 14
  def member_rank(:middle_daughter), do: 15
  def member_rank(:young_son), do: 16
  def member_rank(:young_daugter), do: 17
  def member_rank(:old_little_son), do: 18
  def member_rank(:old_little_daughter), do: 19
  def member_rank(:little_son), do: 20
  def member_rank(:little_daughter), do: 21
  def member_rank(:middle_little_son), do: 22
  def member_rank(:middle_little_daugter), do: 23
end
