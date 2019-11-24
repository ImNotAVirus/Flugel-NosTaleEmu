defmodule WorldServer.Packets.Entity.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.Entity.Views
  """

  use ElvenGard.View

  alias WorldServer.Structures.Character
  alias WorldServer.Enums.Entity, as: EnumsEntity

  @spec render(atom, term) :: String.t()
  def render(:stat, %Character{} = character) do
    %{
      id: _id
    } = character

    # TODO: Load it from CharacterManagement Service
    hp = 25_000
    hp_max = 25_000
    mp = 10_000
    mp_max = 10_000

    "stat #{hp} #{hp_max} #{mp} #{mp_max} 0 0"
  end

  # TODO: Later, add clauses for mobs, npc, mates, ...
  def render(:eff, %{target: %Character{}} = params) do
    %{
      target: target,
      value: value
    } = params

    %Character{id: character_id} = target
    entity_type = EnumsEntity.type(:character)

    "eff #{entity_type} #{character_id} #{value}"
  end
end
