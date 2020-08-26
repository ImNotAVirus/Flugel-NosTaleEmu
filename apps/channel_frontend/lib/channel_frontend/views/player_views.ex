defmodule ChannelFrontend.PlayerViews do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.PlayerViews
  """

  use ElvenGard.View

  import ChannelCaching.Character, only: [character: 2, is_character: 1]

  alias Core.CharacterEnums
  alias Core.PacketHelpers

  defguardp is_gm(authorities) when is_list(authorities) and authorities != []

  @spec render(atom(), any()) :: String.t()
  def render(:tit, char_record) when is_character(char_record) do
    name = character(char_record, :name)
    class = character(char_record, :class)
    "tit #{String.capitalize("#{class}")} #{name}"
  end

  def render(:c_info, %{character: char_record, authority: authority})
      when is_character(char_record) do
    id = character(char_record, :id)
    name = character(char_record, :name)
    group_id = character(char_record, :group_id)
    compliment = character(char_record, :compliment)
    morph = character(char_record, :morph)
    morph_upgrade = character(char_record, :morph_upgrade)
    reputation = character(char_record, :reputation)

    invisible = char_record |> character(:invisible) |> PacketHelpers.serialize_boolean()
    arena_winner = char_record |> character(:arena_winner) |> PacketHelpers.serialize_boolean()

    class = char_record |> character(:class) |> CharacterEnums.class(:value)
    gender = char_record |> character(:gender) |> CharacterEnums.gender(:value)
    hair_style = char_record |> character(:hair_style) |> CharacterEnums.hair_style(:value)
    hair_color = char_record |> character(:hair_color) |> CharacterEnums.hair_color(:value)

    # TODO: Get Family from cache
    family_id = if is_gm(authority), do: 1, else: -1
    family_name = if is_gm(authority), do: "Alchemists", else: "-"
    family_level = if is_gm(authority), do: 20, else: -1

    name_color =
      if is_gm(authority),
        do: CharacterEnums.name_appearance(:game_master),
        else: CharacterEnums.name_appearance(:player)

    reputation_icon =
      if is_gm(authority),
        do: CharacterEnums.reputation(:legendary_heros),
        else: reputation_icon(reputation)

    "c_info #{name} - #{group_id} #{family_id} #{family_name} #{id} #{name_color} #{gender}" <>
      " #{hair_style} #{hair_color} #{class} #{reputation_icon} #{compliment} #{morph} " <>
      "#{invisible} #{family_level} #{morph_upgrade} #{arena_winner}"
  end

  def render(:fd, char_record) when is_character(char_record) do
    reputation = character(char_record, :reputation)
    dignity = character(char_record, :dignity)

    dignity_icon = dignity_icon(dignity)
    reput_icon = reputation_icon(reputation)

    "fd #{reputation} #{reput_icon} #{dignity} #{dignity_icon}"
  end

  def render(:lev, char_record) when is_character(char_record) do
    level = character(char_record, :level)
    job_level = character(char_record, :job_level)
    hero_level = character(char_record, :hero_level)
    level_xp = character(char_record, :level_xp)
    job_level_xp = character(char_record, :job_level_xp)
    hero_level_xp = character(char_record, :hero_level_xp)
    reputation = character(char_record, :reputation)
    level_xp_max = character(char_record, :level_xp_max)
    job_level_xp_max = character(char_record, :job_level_xp_max)
    hero_level_xp_max = character(char_record, :hero_level_xp_max)
    cp = character(char_record, :cp)

    "lev #{level} #{level_xp} #{job_level} #{job_level_xp} #{level_xp_max} #{job_level_xp_max} " <>
      "#{reputation} #{cp} #{hero_level_xp} #{hero_level} #{hero_level_xp_max}"
  end

  def render(:sc, char_record) when is_character(char_record) do
    level = character(char_record, :level)
    class = char_record |> character(:class) |> CharacterEnums.class(:value)

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

  def render(:ski, skill_vnums) when is_list(skill_vnums) do
    skills_str = PacketHelpers.serialize_list(skill_vnums, " ")
    "ski #{skills_str}"
  end

  def render(:fs, char_record) when is_character(char_record) do
    faction = char_record |> character(:faction) |> CharacterEnums.faction(:value)
    "fs #{faction}"
  end

  def render(:rage, char_record) when is_character(char_record) do
    rage_points = character(char_record, :rage_points)
    rage_points_max = character(char_record, :rage_points_max)
    "rage #{rage_points} #{rage_points_max}"
  end

  def render(:rsfi, _) do
    act = 1
    act_part = 1
    ts = 0
    ts_max = 0

    "rsfi #{act} #{act_part} 0 0 #{ts} #{ts_max}"
  end

  ## Helpers

  @doc false
  @spec dignity_icon(integer) :: atom
  defp dignity_icon(dignity) do
    dignity_map = [
      {-100, CharacterEnums.dignity(:basic)},
      {-201, CharacterEnums.dignity(:suspected)},
      {-401, CharacterEnums.dignity(:bluffed_name_only)},
      {-601, CharacterEnums.dignity(:not_qualified_for)},
      {-801, CharacterEnums.dignity(:useless)},
      {nil, CharacterEnums.dignity(:stupid_minded)}
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
      {-800, CharacterEnums.reputation(:stupid_minded)},
      {-600, CharacterEnums.reputation(:useless)},
      {-400, CharacterEnums.reputation(:not_qualified_for)},
      {-200, CharacterEnums.reputation(:bluffed_name_only)},
      {-99, CharacterEnums.reputation(:suspected)},
      {0, CharacterEnums.reputation(:basic)},
      {250, CharacterEnums.reputation(:beginner)},
      {500, CharacterEnums.reputation(:trainee_g)},
      {750, CharacterEnums.reputation(:trainee_b)},
      {1_000, CharacterEnums.reputation(:trainee_r)},
      {2_250, CharacterEnums.reputation(:the_experienced_g)},
      {3_500, CharacterEnums.reputation(:the_experienced_b)},
      {5_000, CharacterEnums.reputation(:the_experienced_r)},
      {9_500, CharacterEnums.reputation(:battle_soldier_g)},
      {19_000, CharacterEnums.reputation(:battle_soldier_b)},
      {25_000, CharacterEnums.reputation(:battle_soldier_r)},
      {40_000, CharacterEnums.reputation(:expert_g)},
      {60_000, CharacterEnums.reputation(:expert_b)},
      {85_000, CharacterEnums.reputation(:expert_r)},
      {115_000, CharacterEnums.reputation(:leader_g)},
      {150_000, CharacterEnums.reputation(:leader_b)},
      {190_000, CharacterEnums.reputation(:leader_r)},
      {235_000, CharacterEnums.reputation(:master_g)},
      {185_000, CharacterEnums.reputation(:master_b)},
      {350_000, CharacterEnums.reputation(:master_r)},
      {500_000, CharacterEnums.reputation(:nos_g)},
      {1_500_000, CharacterEnums.reputation(:nos_b)},
      {2_500_000, CharacterEnums.reputation(:nos_r)},
      {3_750_000, CharacterEnums.reputation(:elite_g)},
      {5_000_000, CharacterEnums.reputation(:elite_b)},
      {nil, CharacterEnums.reputation(:elite_r)}
    ]

    Enum.find_value(reputation_map, fn
      {nil, val} -> val
      {limit, val} -> if reputation < limit, do: val
    end)
  end

  # TODO: Transform Enums into macros (can be used in guards)
  @type_adventurer CharacterEnums.class(:adventurer)
  @type_swordman CharacterEnums.class(:swordman)
  @type_archer CharacterEnums.class(:archer)
  @type_magician CharacterEnums.class(:magician)
  @type_wrestler CharacterEnums.class(:wrestler)

  @doc false
  @spec stat_char_types(integer) :: {integer, integer}
  defp stat_char_types(class) when class == @type_adventurer, do: {0, 1}
  defp stat_char_types(class) when class == @type_swordman, do: {0, 1}
  defp stat_char_types(class) when class == @type_archer, do: {1, 0}
  defp stat_char_types(class) when class == @type_magician, do: {2, 1}
  defp stat_char_types(class) when class == @type_wrestler, do: {0, 1}
end
