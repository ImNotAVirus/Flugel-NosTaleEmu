defmodule ChannelCaching.CharacterFrontend do
  @moduledoc """
  TODO: Documentation
  """

  @record_name :character_frontend
  @keys [:character_id, :pid]

  use Core.MnesiaHelpers, record_name: @record_name, keys: @keys

  import Record, only: [defrecord: 2]

  defrecord @record_name, @keys

  @type t ::
          record(
            :character_frontend,
            character_id: pos_integer(),
            pid: pid()
          )

  ## Public API

  @doc """
  Create a new structure
  """
  @spec new(pos_integer(), pid()) :: __MODULE__.t()
  def new(character_id, pid) when is_pid(pid) do
    character_frontend(
      character_id: character_id,
      pid: pid
    )
  end
end
