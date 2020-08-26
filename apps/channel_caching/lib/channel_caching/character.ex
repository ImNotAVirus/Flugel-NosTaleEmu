defmodule ChannelCaching.Character do
  @moduledoc """
  TODO: Documentation
  """

  @record_name :character
  @struct_keys [
    :id,
    :name,
    :slot,
    :gender,
    :hair_color,
    :hair_style,
    :map_id,
    :map_x,
    :map_y,
    :class,
    :faction,
    :additional_hp,
    :additional_mp,
    :gold,
    :biography,
    :level,
    :job_level,
    :hero_level,
    :level_xp,
    :job_level_xp,
    :hero_level_xp,
    :sp_point,
    :sp_additional_point,
    :rage_point,
    :max_mate_count,
    :reputation,
    :dignity,
    :compliment,
    :act4_dead,
    :act4_kill,
    :act4_points,
    :arena_winner,
    :talent_win,
    :talent_lose,
    :talent_surrender,
    :master_points,
    :master_ticket,
    :miniland_intro,
    :miniland_state,
    :miniland_makepoints,
    :game_options
  ]

  @virtual_keys [
    :hp,
    :mp
  ]

  @keys @struct_keys ++ @virtual_keys

  use Core.MnesiaHelpers, record_name: @record_name, keys: @keys

  import Record, only: [defrecord: 2]

  alias DatabaseService.Player.Character
  alias Core.PlayerAlgorithms

  defrecord @record_name, @keys

  @type t ::
          record(
            :character,
            # From struct
            id: pos_integer(),
            name: String.t(),
            slot: non_neg_integer(),
            gender: atom(),
            hair_color: atom(),
            hair_style: atom(),
            map_id: non_neg_integer(),
            map_x: non_neg_integer(),
            map_y: non_neg_integer(),
            class: atom(),
            faction: atom(),
            additional_hp: non_neg_integer(),
            additional_mp: non_neg_integer(),
            gold: non_neg_integer(),
            biography: String.t(),
            level: pos_integer(),
            job_level: pos_integer(),
            hero_level: non_neg_integer(),
            level_xp: non_neg_integer(),
            job_level_xp: non_neg_integer(),
            hero_level_xp: non_neg_integer(),
            sp_point: non_neg_integer(),
            sp_additional_point: non_neg_integer(),
            rage_point: non_neg_integer(),
            max_mate_count: pos_integer(),
            reputation: non_neg_integer(),
            dignity: integer(),
            compliment: non_neg_integer(),
            act4_dead: non_neg_integer(),
            act4_kill: non_neg_integer(),
            act4_points: non_neg_integer(),
            arena_winner: boolean(),
            talent_win: non_neg_integer(),
            talent_lose: non_neg_integer(),
            talent_surrender: non_neg_integer(),
            master_points: non_neg_integer(),
            master_ticket: non_neg_integer(),
            miniland_intro: String.t(),
            miniland_state: atom(),
            miniland_makepoints: non_neg_integer(),
            game_options: [atom(), ...],
            # Virtual fields
            hp: non_neg_integer(),
            mp: non_neg_integer()
          )

  ## Public API

  @doc """
  Create a new structure
  """
  @spec new(Character.t()) :: __MODULE__.t()
  def new(%Character{} = character) do
    %Character{class: class, level: level} = character

    # TODO: Later add stuff stats and create a function `base_hp/1` and `base_mp/1`
    hp = PlayerAlgorithms.get_hp(class, level) + character.additional_hp
    mp = 5_000

    character(
      # From struct
      id: character.id,
      name: character.name,
      slot: character.slot,
      gender: character.gender,
      hair_color: character.hair_color,
      hair_style: character.hair_style,
      map_id: character.map_id,
      map_x: character.map_x,
      map_y: character.map_y,
      class: character.class,
      faction: character.faction,
      additional_hp: character.additional_hp,
      additional_mp: character.additional_mp,
      gold: character.gold,
      biography: character.biography,
      level: character.level,
      job_level: character.job_level,
      hero_level: character.hero_level,
      level_xp: character.level_xp,
      job_level_xp: character.job_level_xp,
      hero_level_xp: character.hero_level_xp,
      sp_point: character.sp_point,
      sp_additional_point: character.sp_additional_point,
      rage_point: character.rage_point,
      max_mate_count: character.max_mate_count,
      reputation: character.reputation,
      dignity: character.dignity,
      compliment: character.compliment,
      act4_dead: character.act4_dead,
      act4_kill: character.act4_kill,
      act4_points: character.act4_points,
      arena_winner: character.arena_winner,
      talent_win: character.talent_win,
      talent_lose: character.talent_lose,
      talent_surrender: character.talent_surrender,
      master_points: character.master_points,
      master_ticket: character.master_ticket,
      miniland_intro: character.miniland_intro,
      miniland_state: character.miniland_state,
      miniland_makepoints: character.miniland_makepoints,
      game_options: character.game_options,

      # Virtual fields
      hp: hp,
      mp: mp
    )
  end
end
