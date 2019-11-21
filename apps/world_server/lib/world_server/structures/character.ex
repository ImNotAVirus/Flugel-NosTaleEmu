defmodule WorldServer.Structures.Character do
  @moduledoc """
  TODO: Replace this module by an Ecto schema
  """

  alias WorldServer.Enums.Character, as: EnumChar

  @keys [
    :slot,
    :name,
    :gender,
    :hair_style,
    :hair_color
  ]

  @additional_keys [
    level: 1,
    job_level: 1,
    hero_level: 0,
    class: EnumChar.class_type(:adventurer)
  ]

  @enforce_keys @keys
  defstruct @keys ++ @additional_keys

  @type t :: %__MODULE__{
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
