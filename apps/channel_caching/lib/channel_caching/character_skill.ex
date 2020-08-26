defmodule ChannelCaching.CharacterSkill do
  @moduledoc """
  TODO: Documentation
  """

  @record_name :character_skill
  @keys [:character_id, :vnum]

  use Core.MnesiaHelpers, record_name: @record_name, keys: @keys

  import Record, only: [defrecord: 2]

  defrecord @record_name, @keys

  @type t ::
          record(
            :character_skill,
            character_id: pos_integer(),
            vnum: pos_integer()
          )

  ## Public API

  @doc """
  Create a new structure
  """
  @spec new(pos_integer(), pos_integer()) :: __MODULE__.t()
  def new(character_id, vnum) when is_integer(vnum) do
    character_skill(
      character_id: character_id,
      vnum: vnum
    )
  end
end
