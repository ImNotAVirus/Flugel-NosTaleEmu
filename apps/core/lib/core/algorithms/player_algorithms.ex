defmodule Core.PlayerAlgorithms do
  @moduledoc """
  TODO: Documentation
  """

  import Core.Algorithms.PlayerHpHelpers, only: [define_get_hp: 2]

  @level_max 99
  # @change_class_min_lvl 15

  for l <- 1..@level_max, do: define_get_hp(:adventurer, l)
  # for l <- 1..@change_class_min_lvl, do: define_get_hp(:swordman, l)
  for l <- 1..@level_max, do: define_get_hp(:swordman, l)
  # for l <- 1..@change_class_min_lvl, do: define_get_hp(:magician, l)
  for l <- 1..@level_max, do: define_get_hp(:magician, l)
  # for l <- 1..@change_class_min_lvl, do: define_get_hp(:archer, l)
  for l <- 1..@level_max, do: define_get_hp(:archer, l)
  # for l <- 1..@change_class_min_lvl, do: define_get_hp(:wrestler, l)
  for l <- 1..@level_max, do: define_get_hp(:wrestler, l)
end
