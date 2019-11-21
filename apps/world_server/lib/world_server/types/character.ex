defmodule WorldServer.Types.Character do
  @moduledoc """
  TODO: Documentation for WorldServer.Types.Character
  """

  use ElvenGard.Type

  alias WorldServer.Enums.Character, as: EnumChar

  @keys [
    :slot,
    :name,
    :gender,
    :hair_style,
    :hair_color,
    :equipments,
    :pets
  ]

  @additional_keys [
    level: 1,
    job_level: 1,
    hero_level: 0,
    class: EnumChar.class_type(:adventurer),
    quest_completion: 1,
    quest_part: 1
  ]

  @enforce_keys @keys
  defstruct @keys ++ @additional_keys

  @type t :: %__MODULE__{
          slot: non_neg_integer,
          name: String.t(),
          gender: non_neg_integer,
          hair_style: non_neg_integer,
          hair_color: non_neg_integer,
          equipments: [Equipment.t(), ...],
          pets: [Pet.t(), ...],
          level: non_neg_integer,
          job_level: non_neg_integer,
          hero_level: non_neg_integer,
          class: non_neg_integer,
          quest_completion: non_neg_integer,
          quest_part: non_neg_integer
        }

  @impl true
  def encode(%__MODULE__{} = character, _opts) do
    %__MODULE__{
      slot: slot,
      name: name,
      gender: gender,
      hair_style: hair_style,
      hair_color: hair_color,
      class: class,
      level: level,
      hero_level: hero_level,
      equipments: equipments,
      job_level: job_level,
      quest_completion: quest_completion,
      quest_part: quest_part,
      pets: pets
    } = character

    design = 0

    "clist #{slot} #{name} 0 #{gender} #{hair_style} #{hair_color} 0 #{class}" <>
      " #{level} #{hero_level} #{equipments} #{job_level} #{quest_completion} " <>
      "#{quest_part} #{pets} #{design}"
  end

  @impl true
  def decode(_val, _opts), do: :unimplemented
end
