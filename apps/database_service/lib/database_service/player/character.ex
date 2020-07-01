defmodule DatabaseService.Player.Character do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import EctoBitfield

  alias DatabaseService.Enums.{
    CharacterClassType,
    FactionType,
    GenderType,
    HairColorType,
    HairStyleType,
    MinilandState
  }

  defbitfield GameOptions,
    exchange_blocked: round(:math.pow(2, 1)),
    friend_request_blocked: round(:math.pow(2, 2)),
    family_request_blocked: round(:math.pow(2, 3)),
    whisper_blocked: round(:math.pow(2, 4)),
    group_request_blocked: round(:math.pow(2, 5)),
    mouse_aim_lock: round(:math.pow(2, 9)),
    global_chat_blocked: round(:math.pow(2, 10)),
    quick_get_up: round(:math.pow(2, 11)),
    emoticons_blocked: round(:math.pow(2, 12)),
    hp_stat_blocked: round(:math.pow(2, 13)),
    buff_counter_blocked: round(:math.pow(2, 14)),
    miniland_invite_blocked: round(:math.pow(2, 15)),
    hats_hidden: round(:math.pow(2, 16)),
    ui_locked: round(:math.pow(2, 17))

  schema "characters" do
    belongs_to :account, DatabaseService.Player.Account
    field :name, :string
    field :slot, :integer
    field :disabled, :boolean

    field :class, CharacterClassType
    field :faction, FactionType
    field :gender, GenderType
    field :hair_color, HairColorType
    field :hair_style, HairStyleType

    field :map_id, :integer
    field :map_x, :integer
    field :map_y, :integer

    field :additional_hp, :integer
    field :additional_mp, :integer
    field :gold, :integer
    field :biography, :string

    field :level, :integer
    field :job_level, :integer
    field :hero_level, :integer
    field :level_xp, :integer
    field :job_level_xp, :integer
    field :hero_level_xp, :integer

    field :sp_point, :integer
    field :sp_additional_point, :integer
    field :rage_point, :integer
    field :max_mate_count, :integer

    field :reputation, :integer
    field :dignity, :integer
    field :compliment, :integer

    field :act4_dead, :integer
    field :act4_kill, :integer
    field :act4_points, :integer
    field :arena_winner, :boolean
    field :talent_win, :integer
    field :talent_lose, :integer
    field :talent_surrender, :integer
    field :master_points, :integer
    field :master_ticket, :integer

    field :miniland_intro, :string
    field :miniland_state, MinilandState
    field :miniland_makepoints, :integer

    field :game_options, __MODULE__.GameOptions

    timestamps()
  end

  @required_fields [
    :account_id,
    :name,
    :slot,
    :gender,
    :hair_color,
    :hair_style,
    :map_id,
    :map_x,
    :map_y
  ]

  @optional_fields [
    :disabled,
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

  @fields @required_fields ++ @optional_fields
  @name_regex ~r/^[\x21-\x7E\xA1-\xAC\xAE-\xFF\x{4e00}-\x{9fa5}\x{0E01}-\x{0E3A}\x{0E3F}-\x{0E5B}\x2E]{4,14}$/u

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, @fields)
    |> cast_assoc(:account)
    |> validate_required(@required_fields)
    |> validate_format(:name, @name_regex)
    |> update_change(:name, &String.trim/1)
    |> unique_constraint(:name)
  end

  @doc false
  def disabled_changeset(account, attrs) do
    account
    |> cast(attrs, @fields)
    |> cast_assoc(:account)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 4, max: 32)
    |> unique_constraint(:name)
  end
end
