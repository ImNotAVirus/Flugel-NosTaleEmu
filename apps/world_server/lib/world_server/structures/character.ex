defmodule WorldServer.Structures.Character do
  @moduledoc """
  TODO: Replace this module by an Ecto schema
  """

  alias WorldServer.Enums.Character, as: EnumChar

  @keys [
    id: 1,
    slot: 1,
    name: "DarkyZ",
    gender: 1,
    hair_style: 1,
    hair_color: 1,
    level: 1,
    reputation: 0,
    dignity: 0,
    job_level: 1,
    hero_level: 0,
    level_xp: 0,
    job_level_xp: 0,
    hero_level_xp: 0,
    class: EnumChar.class_type(:adventurer)
  ]

  defstruct @keys

  @type t :: %__MODULE__{
          id: non_neg_integer,
          slot: non_neg_integer,
          name: String.t(),
          gender: non_neg_integer,
          hair_style: non_neg_integer,
          hair_color: non_neg_integer,
          level: non_neg_integer,
          job_level: non_neg_integer,
          hero_level: non_neg_integer,
          class: non_neg_integer
        }
end
