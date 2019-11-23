defmodule WorldServer.Packets.Player.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.Player.Views
  """

  use ElvenGard.View

  alias WorldServer.Structures.Character
  alias WorldServer.Enums.Character, as: EnumChar

  @spec render(atom, term) :: String.t()
  def render(:tit, %Character{} = character) do
    %Character{class: class, name: name} = character
    "tit #{EnumChar.class_str(class)} #{name}"
  end

  def render(:c_info, %Character{} = character) do
    %Character{
      id: id,
      name: name,
      class: class,
      gender: gender,
      hair_style: hair_style,
      hair_color: hair_color
    } = character

    group_id = -1
    family_id = 1
    family_name = "Alchemists"
    name_color = EnumChar.name_appearance(:game_master)
    reputation_icon = EnumChar.reputation(:legendary_heros)
    compliment = 0
    morph = 0
    invisible = false
    family_level = 20
    sp_upgrade = 0
    arena_winner = 0

    invisible_int = if invisible, do: 1, else: 0

    "c_info #{name} - #{group_id} #{family_id} #{family_name} #{id} #{name_color} #{gender}" <>
      " #{hair_style} #{hair_color} #{class} #{reputation_icon} #{compliment} #{morph} " <>
      "#{invisible_int} #{family_level} #{sp_upgrade} #{arena_winner}"
  end

  def render(:fd, %Character{} = character) do
    %Character{id: _id} = character

    # TODO: Get it from service
    reput = 5_000_000
    dignity = 100

    dignity_icon = dignity_icon(dignity)
    reput_icon = reputation_icon(reput)

    "fd #{reput} #{reput_icon} #{dignity} #{dignity_icon}"
  end

  #
  # Function Helpers
  #

  @doc false
  @spec dignity_icon(integer) :: atom
  defp dignity_icon(dignity) do
    dignity_map = [
      {-100, EnumChar.dignity(:basic)},
      {-201, EnumChar.dignity(:suspected)},
      {-401, EnumChar.dignity(:bluffed_name_only)},
      {-601, EnumChar.dignity(:not_qualified_for)},
      {-801, EnumChar.dignity(:useless)},
      {nil, EnumChar.dignity(:stupid_minded)}
    ]

    Enum.find_value(dignity_map, fn
      {nil, val} -> val
      {limit, val} -> if dignity > limit, do: val
    end)
  end

  @doc false
  @spec reputation_icon(integer) :: atom
  defp reputation_icon(reputation) do
    reputation_map = [
      {-800, EnumChar.reputation(:stupid_minded)},
      {-600, EnumChar.reputation(:useless)},
      {-400, EnumChar.reputation(:not_qualified_for)},
      {-200, EnumChar.reputation(:bluffed_name_only)},
      {-99, EnumChar.reputation(:suspected)},
      {0, EnumChar.reputation(:basic)},
      {250, EnumChar.reputation(:beginner)},
      {500, EnumChar.reputation(:trainee_g)},
      {750, EnumChar.reputation(:trainee_b)},
      {1000, EnumChar.reputation(:trainee_r)},
      {2250, EnumChar.reputation(:the_experienced_g)},
      {3500, EnumChar.reputation(:the_experienced_b)},
      {5000, EnumChar.reputation(:the_experienced_r)},
      {9500, EnumChar.reputation(:battle_soldier_g)},
      {19000, EnumChar.reputation(:battle_soldier_b)},
      {25000, EnumChar.reputation(:battle_soldier_r)},
      {40000, EnumChar.reputation(:expert_g)},
      {60000, EnumChar.reputation(:expert_b)},
      {85000, EnumChar.reputation(:expert_r)},
      {115_000, EnumChar.reputation(:leader_g)},
      {150_000, EnumChar.reputation(:leader_b)},
      {190_000, EnumChar.reputation(:leader_r)},
      {235_000, EnumChar.reputation(:master_g)},
      {185_000, EnumChar.reputation(:master_b)},
      {350_000, EnumChar.reputation(:master_r)},
      {500_000, EnumChar.reputation(:nos_g)},
      {1_500_000, EnumChar.reputation(:nos_b)},
      {2_500_000, EnumChar.reputation(:nos_r)},
      {3_750_000, EnumChar.reputation(:elite_g)},
      {5_000_000, EnumChar.reputation(:elite_b)},
      {nil, EnumChar.reputation(:elite_r)}
    ]

    Enum.find_value(reputation_map, fn
      {nil, val} -> val
      {limit, val} -> if reputation <= limit, do: val
    end)
  end
end
