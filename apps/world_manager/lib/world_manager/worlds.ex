defmodule WorldManager.Worlds do
  @moduledoc false

  alias WorldManager.World

  @doc false
  @spec all(pid) :: [World.t(), ...]
  def all(conn) do
    conn
    |> Redix.command!(["SMEMBERS", "world:__index__"])
    |> Stream.map(&Redix.command!(conn, ["HGETALL", &1]))
    |> Enum.map(&World.from_redis_hash/1)
  end

  @doc """
  Returns the created world or the existing one

  TODO: FIX RACE CONDITION on append and get id !!!
  """
  @spec insert(pid, map) :: {:ok, integer} | {:error, term}
  def insert(conn, world_name) do
    case get_by_name(conn, world_name) do
      %World{} = x ->
        x

      nil ->
        id = next_id!(conn)
        do_insert(conn, id, world_name)
    end
  end

  @doc false
  @spec get_by_name(pid, String.t()) :: World.t() | nil
  def get_by_name(conn, world_name) do
    key_name = world_name_as_key(world_name)
    keyname = "world:#{key_name}"

    case Redix.command(conn, ["HGETALL", keyname]) do
      {:ok, []} ->
        nil

      {:ok, attrs} ->
        World.from_redis_hash(attrs)
    end
  end

  #
  # Helpers
  #

  @doc false
  @spec world_name_as_key(String.t()) :: String.t()
  defp world_name_as_key(name) do
    name
    |> normalize_name()
    |> String.downcase()
  end

  @doc false
  @spec normalize_name(String.t()) :: String.t()
  defp normalize_name(name) do
    name
    |> String.trim()
    |> String.replace(" ", "")
  end

  @doc false
  @spec next_id!(pid) :: integer
  defp next_id!(conn) do
    Redix.command!(conn, ["INCR", "world:__count__"])
  end

  @doc false
  @spec do_insert(pid, integer, String.t()) :: {:ok, list} | {:error, term}
  defp do_insert(conn, id, world_name) do
    key_name = world_name_as_key(world_name)
    norm_name = normalize_name(world_name)
    keyname = "world:#{key_name}"
    query_insert = ["HMSET", keyname, "id", id, "name", norm_name]
    query_index = ["SADD", "world:__index__", keyname]

    Redix.transaction_pipeline!(conn, [query_insert, query_index])
    World.new(id, world_name)
  end
end
