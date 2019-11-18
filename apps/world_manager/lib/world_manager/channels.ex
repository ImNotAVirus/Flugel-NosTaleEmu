defmodule WorldManager.Channels do
  @moduledoc false

  alias WorldManager.{Channel, World, Worlds}

  @doc false
  @spec all(pid) :: [Channel.t(), ...]
  def all(conn) do
    conn
    |> Redix.command!(["SMEMBERS", "channel:__index__"])
    |> Stream.map(&Redix.command!(conn, ["HGETALL", &1]))
    |> Enum.map(&Channel.from_redis_hash/1)
  end

  @doc false
  @spec insert(pid, map) :: Channel.t()
  def insert(conn, attrs) do
    %{world_name: tmp_world_name} = attrs

    %World{
      name: world_name,
      id: world_id
    } = Worlds.insert(conn, tmp_world_name)

    channel_id = next_id!(conn, world_id)

    keyname = "channel:#{world_id}:#{channel_id}"

    channel =
      attrs
      |> Map.put(:world_id, world_id)
      |> Map.put(:world_name, world_name)
      |> Map.put(:channel_id, channel_id)
      |> Channel.new()

    query_insert =
      channel
      |> Channel.to_redis_hash()
      |> List.insert_at(0, keyname)
      |> List.insert_at(0, "HMSET")

    query_index = ["SADD", "channel:__index__", keyname]

    Redix.transaction_pipeline!(conn, [query_insert, query_index])

    channel
  end

  @doc false
  @spec set_monitor(pid, integer, integer, reference) ::
          {:ok, String.t()} | {:error, term}
  def set_monitor(conn, world_id, channel_id, ref) do
    keyname = "channel_monitor#{inspect(ref)}"
    query = ["HMSET", keyname, "world_id", world_id, "channel_id", channel_id]

    Redix.command(conn, query)
  end

  @doc false
  @spec delete_monitored(pid, reference) :: {:ok, {integer, integer}} | {:error, term}
  def delete_monitored(conn, ref) do
    keyname = "channel_monitor#{inspect(ref)}"
    query_get = ["HMGET", keyname, "world_id", "channel_id"]

    case Redix.command(conn, query_get) do
      {:ok, nil} ->
        {:error, :unknown_channel}

      {:ok, [world_id, channel_id]} ->
        world_id_int = String.to_integer(world_id)
        channel_id_int = String.to_integer(channel_id)
        do_delete_monitored(conn, ref, world_id_int, channel_id_int)
    end
  end

  #
  # Helpers
  #

  @doc false
  @spec next_id!(pid, integer) :: integer
  defp next_id!(conn, world_id) do
    query_disconnected = ["LPOP", "channel:#{world_id}:__missing__"]
    query_increment = ["INCR", "channel:#{world_id}:__count__"]

    case Redix.command(conn, query_disconnected) do
      {:ok, nil} ->
        Redix.command!(conn, query_increment)

      {:ok, x} ->
        String.to_integer(x)
    end
  end

  @doc false
  @spec do_delete_monitored(pid, reference, integer, integer) ::
          {:ok, {integer, integer}} | {:error, term}
  defp do_delete_monitored(conn, ref, world_id, channel_id) do
    mon_keyname = "channel_monitor#{inspect(ref)}"
    chn_keyname = "channel:#{world_id}:#{channel_id}"
    msn_keyname = "channel:#{world_id}:__missing__"

    query_del_ref = ["DEL", mon_keyname]
    query_del_channel = ["DEL", chn_keyname]
    query_del_index = ["SREM", "channel:__index__", chn_keyname]
    query_add_missing = ["RPUSH", msn_keyname, channel_id]

    res =
      Redix.transaction_pipeline(conn, [
        query_del_ref,
        query_del_channel,
        query_del_index,
        query_add_missing
      ])

    case res do
      {:ok, _} ->
        {:ok, {world_id, channel_id}}

      x ->
        x
    end
  end
end
