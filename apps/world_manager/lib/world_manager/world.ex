defmodule WorldManager.World do
  @moduledoc false

  import Record, only: [defrecord: 2]

  @record_name :world
  @keys [:name, :id]
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

  ## Mnesia Helpers
  ## TODO: Make `using` macro and inject theses 2 functions

  @doc false
  @spec mnesia_table_name() :: atom()
  def mnesia_table_name() do
    @record_name
  end

  @doc false
  @spec mnesia_attributes() :: [atom(), ...]
  def mnesia_attributes() do
    @keys
  end
end
