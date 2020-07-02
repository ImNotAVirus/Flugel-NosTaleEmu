defmodule WorldManager.Worlds do
  @moduledoc false

  import Record, only: [is_record: 1]
  import WorldManager.World

  alias WorldManager.World

  ## Public API

  @doc """
  Returns all existing worlds
  """
  @spec all() :: [World.t(), ...]
  def all() do
    match = World.match_all_record()
    :mnesia.dirty_match_object(match)
  end

  @doc """
  Returns the created world or the existing one
  """
  @spec insert_if_not_exists(String.t()) :: {:ok, World.t()} | {:error, any()}
  def insert_if_not_exists(world_name) do
    # FIXME: Race condition (need to wrap everything into a transaction)
    case get_by_name(world_name) do
      nil ->
        table = World.mnesia_table_name()
        id = :mnesia.dirty_update_counter(:auto_increment_counter, table, 1)
        record = World.new(id, world_name)
        write_world(record)

      record ->
        {:ok, record}
    end
  end

  @doc """
  Get a world record by name
  """
  @spec get_by_name(String.t()) :: World.t() | nil
  def get_by_name(world_name) do
    table = World.mnesia_table_name()
    key_name = normalize_name(world_name)

    case :mnesia.dirty_read(table, key_name) do
      [] -> nil
      [attrs] -> attrs
    end
  end

  ## Helpers

  @doc false
  @spec normalize_name(String.t()) :: String.t()
  defp normalize_name(name) do
    String.replace(name, " ", "")
  end

  @doc false
  @spec write_world(World.t()) :: {:ok, World.t()} | {:error, any()}
  defp write_world(record) when is_record(record) do
    query = fn -> :mnesia.write(record) end

    case :mnesia.transaction(query) do
      {:atomic, :ok} -> {:ok, record}
      {:aborted, x} -> {:error, x}
    end
  end
end
