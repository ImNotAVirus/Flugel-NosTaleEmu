defmodule WorldManager.World do
  @moduledoc """
  TODO: Documentation
  """

  @record_name :world
  @keys [:name, :id]

  use Core.MnesiaHelpers, record_name: @record_name, keys: @keys

  import Record, only: [defrecord: 2]

  defrecord @record_name, @keys

  @type t ::
          record(
            :world,
            name: String.t(),
            id: pos_integer()
          )

  ## Public API

  @doc false
  @spec new(%{id: pos_integer(), name: String.t()}) :: __MODULE__.t()
  def new(%{id: id, name: name}) do
    new(id, name)
  end

  @doc false
  @spec new(pos_integer(), String.t()) :: __MODULE__.t()
  def new(id, name) do
    world(id: id, name: name)
  end
end
