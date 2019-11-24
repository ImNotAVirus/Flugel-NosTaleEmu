defmodule WorldServer.Packets.Player.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.Player.Views
  """

  use ElvenGard.View

  alias WorldServer.Structures.Character
  alias WorldServer.Enums.Character, as: EnumsChar

  @spec render(atom, term) :: String.t()
  def render(:tit, %Character{} = character) do
    %Character{class: class, name: name} = character
    "tit #{EnumsChar.class_str(class)} #{name}"
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
    name_color = EnumsChar.name_appearance(:game_master)
    reputation_icon = EnumsChar.reputation(:legendary_heros)
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
    %Character{
      reputation: reputation,
      dignity: dignity
    } = character

    dignity_icon = dignity_icon(dignity)
    reput_icon = reputation_icon(reputation)

    "fd #{reputation} #{reput_icon} #{dignity} #{dignity_icon}"
  end

  def render(:lev, %Character{} = character) do
    %Character{
      level: level,
      job_level: job_level,
      hero_level: hero_level,
      level_xp: level_xp,
      job_level_xp: job_level_xp,
      hero_level_xp: hero_level_xp,
      reputation: reputation
    } = character

    # TODO: Get it from algo service
    level_xp_max = 5_000
    job_level_xp_max = 5_000
    hero_level_xp_max = 5_000
    cp = 50

    "lev #{level} #{level_xp} #{job_level} #{job_level_xp} #{level_xp_max} #{job_level_xp_max} " <>
      "#{reputation} #{cp} #{hero_level_xp} #{hero_level} #{hero_level_xp_max}"
  end

  def render(:sc, %Character{} = character) do
    %Character{
      class: class,
      level: level
    } = character

    # TODO: Get it from InventoryService (stuff specs)
    main_weapon_up = 0
    min_hit_ = 0
    max_hit_ = 0
    hit_rate_ = 0
    crit_hit_rate = 0
    crit_hit_multiplier = 0
    secondary_weapon_up = 0
    secondary_min_hit_ = 0
    secondary_max_hit_ = 0
    secondary_hit_rate_ = 0
    secondary_crit_hit_rate = 0
    secondary_crit_hit_multiplier = 0
    armor_up = 0
    defence_ = 0
    defence_dodge_ = 0
    distance_defence_ = 0
    distance_defence_dodge_ = 0
    magic_defence_ = 0
    fire_resistance = 145
    water_resistance = 15
    light_resistance = 78
    dark_resistance = 85

    # TODO: Get it from algo module
    min_hit = min_hit_ + level * 2 + 15
    max_hit = max_hit_ + level * 2 + 15
    hit_rate = hit_rate_ + level * 2
    secondary_min_hit = Kernel.trunc(secondary_min_hit_ + level * 1.5)
    secondary_max_hit = Kernel.trunc(secondary_max_hit_ + level * 1.5)
    secondary_hit_rate = secondary_hit_rate_ + level * 3
    defence = defence_ + level
    defence_dodge = Kernel.trunc(defence_dodge_ + level * 1.75)
    distance_defence = distance_defence_ + level
    distance_defence_dodge = Kernel.trunc(distance_defence_dodge_ + level * 1.5)
    magic_defence = Kernel.trunc(magic_defence_ + level * 0.75)

    {type, sub_type} = stat_char_types(class)

    "sc #{type} #{main_weapon_up} #{min_hit} #{max_hit} #{hit_rate} #{crit_hit_rate} " <>
      "#{crit_hit_multiplier} #{sub_type} #{secondary_weapon_up} #{secondary_min_hit}" <>
      " #{secondary_max_hit} #{secondary_hit_rate} #{secondary_crit_hit_rate} " <>
      "#{secondary_crit_hit_multiplier} #{armor_up} #{defence} #{defence_dodge} " <>
      "#{distance_defence} #{distance_defence_dodge} #{magic_defence} #{fire_resistance}" <>
      " #{water_resistance} #{light_resistance} #{dark_resistance}"
  end

  def render(:ski, %Character{} = character) do
    %Character{
      id: _id
    } = character

    # TODO: Get player skills from a service
    skill_ids = [
      1525,
      1529,
      1525,
      1529,
      1526,
      1527,
      1528,
      1530,
      1531,
      1532,
      1533,
      1534,
      1535,
      1536,
      1537,
      1538,
      1539,
      1565,
      21,
      25,
      29,
      37,
      41,
      45,
      49,
      53,
      57,
      1540,
      1543,
      1544
    ]

    skills_str = serialize_list(skill_ids, " ")

    "ski #{skills_str}"
  end

  def render(:fs, %Character{} = character) do
    %Character{
      faction: faction
    } = character

    "fs #{faction}"
  end

  #
  # Core functions
  # TODO: Move it inside 'Core' app
  #

  @spec serialize_list([term, ...], String.t()) :: String.t()
  defp serialize_list(enumerable, joiner \\ ".")
  defp serialize_list([], _), do: "-1"
  defp serialize_list([_ | _] = enumerable, joiner), do: Enum.join(enumerable, joiner)

  #
  # Function Helpers
  #

  @doc false
  @spec dignity_icon(integer) :: atom
  defp dignity_icon(dignity) do
    dignity_map = [
      {-100, EnumsChar.dignity(:basic)},
      {-201, EnumsChar.dignity(:suspected)},
      {-401, EnumsChar.dignity(:bluffed_name_only)},
      {-601, EnumsChar.dignity(:not_qualified_for)},
      {-801, EnumsChar.dignity(:useless)},
      {nil, EnumsChar.dignity(:stupid_minded)}
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
      {-800, EnumsChar.reputation(:stupid_minded)},
      {-600, EnumsChar.reputation(:useless)},
      {-400, EnumsChar.reputation(:not_qualified_for)},
      {-200, EnumsChar.reputation(:bluffed_name_only)},
      {-99, EnumsChar.reputation(:suspected)},
      {0, EnumsChar.reputation(:basic)},
      {250, EnumsChar.reputation(:beginner)},
      {500, EnumsChar.reputation(:trainee_g)},
      {750, EnumsChar.reputation(:trainee_b)},
      {1_000, EnumsChar.reputation(:trainee_r)},
      {2_250, EnumsChar.reputation(:the_experienced_g)},
      {3_500, EnumsChar.reputation(:the_experienced_b)},
      {5_000, EnumsChar.reputation(:the_experienced_r)},
      {9_500, EnumsChar.reputation(:battle_soldier_g)},
      {19_000, EnumsChar.reputation(:battle_soldier_b)},
      {25_000, EnumsChar.reputation(:battle_soldier_r)},
      {40_000, EnumsChar.reputation(:expert_g)},
      {60_000, EnumsChar.reputation(:expert_b)},
      {85_000, EnumsChar.reputation(:expert_r)},
      {115_000, EnumsChar.reputation(:leader_g)},
      {150_000, EnumsChar.reputation(:leader_b)},
      {190_000, EnumsChar.reputation(:leader_r)},
      {235_000, EnumsChar.reputation(:master_g)},
      {185_000, EnumsChar.reputation(:master_b)},
      {350_000, EnumsChar.reputation(:master_r)},
      {500_000, EnumsChar.reputation(:nos_g)},
      {1_500_000, EnumsChar.reputation(:nos_b)},
      {2_500_000, EnumsChar.reputation(:nos_r)},
      {3_750_000, EnumsChar.reputation(:elite_g)},
      {5_000_000, EnumsChar.reputation(:elite_b)},
      {nil, EnumsChar.reputation(:elite_r)}
    ]

    Enum.find_value(reputation_map, fn
      {nil, val} -> val
      {limit, val} -> if reputation <= limit, do: val
    end)
  end

  @type_adventurer EnumsChar.class_type(:adventurer)
  @type_swordman EnumsChar.class_type(:swordman)
  @type_archer EnumsChar.class_type(:archer)
  @type_magician EnumsChar.class_type(:magician)
  @type_wrestler EnumsChar.class_type(:wrestler)

  @doc false
  @spec stat_char_types(integer) :: {integer, integer}
  defp stat_char_types(class) when class == @type_adventurer, do: {0, 1}
  defp stat_char_types(class) when class == @type_swordman, do: {0, 1}
  defp stat_char_types(class) when class == @type_archer, do: {1, 0}
  defp stat_char_types(class) when class == @type_magician, do: {2, 1}
  defp stat_char_types(class) when class == @type_wrestler, do: {0, 1}
end
