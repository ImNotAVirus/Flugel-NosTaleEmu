defmodule WorldManager.Channels do
  @moduledoc false

  import Record, only: [is_record: 1]
  import WorldManager.Channel
  import WorldManager.World

  alias WorldManager.{Channel, Worlds}

  ## Public API

  @doc """
  Returns all existing channels
  """
  @spec all() :: [Channel.t(), ...]
  def all() do
    table = Channel.mnesia_table_name()
    :mnesia.dirty_match_object({table, :_, :_, :_, :_, :_, :_, :_})
  end

  @doc """
  Insert a channel into Mnesia and create the required World if not exist
  """
  @spec insert(%{
          world_name: String.t(),
          ip: String.t(),
          port: pos_integer(),
          max_players: pos_integer()
        }) :: {:ok, Channel.t()} | {:error, any()}
  def insert(attrs) do
    %{
      world_name: tmp_world_name,
      ip: ip,
      port: port,
      max_players: max_players
    } = attrs

    table = Channel.mnesia_table_name()

    # Get World informations
    {:ok, record} = Worlds.insert_if_not_exists(tmp_world_name)
    world_id = world(record, :id)
    world_name = world(record, :name)

    # Insert our new channel
    channel_id = :mnesia.dirty_update_counter(:auto_increment_counter, table, 1)
    record = Channel.new(channel_id, world_id, world_name, ip, port, max_players)
    write_channel(record)
  end

  @doc """
  TODO: Documentation
  """
  @spec set_monitor(pos_integer(), pos_integer(), reference()) ::
          {:ok, Channel.t()} | {:error, any()}
  def set_monitor(world_id, channel_id, ref) do
    table = Channel.mnesia_table_name()

    query = fn ->
      case :mnesia.wread({table, {world_id, channel_id}}) do
        [] ->
          {:error, :unknown_channel}

        [record] ->
          new_record = channel(record, monitor: ref)
          :ok = :mnesia.write(new_record)
          {:ok, new_record}
      end
    end

    {:atomic, result} = :mnesia.transaction(query)
    result
  end

  @doc false
  @spec delete_monitored(reference()) :: {:ok, Channel.t()} | {:error, term()}
  def delete_monitored(ref) do
    table = Channel.mnesia_table_name()

    query = fn ->
      case :mnesia.index_read(table, ref, :monitor) do
        [] ->
          {:error, :unknown_channel}

        [record] ->
          id = channel(record, :id)
          :ok = :mnesia.delete({table, id})
          {:ok, record}
      end
    end

    {:atomic, result} = :mnesia.transaction(query)
    result
  end

  ## Helpers

  @doc false
  @spec write_channel(Channel.t()) :: {:ok, Channel.t()} | {:error, any()}
  defp write_channel(record) when is_record(record) do
    query = fn -> :mnesia.write(record) end

    case :mnesia.transaction(query) do
      {:atomic, :ok} -> {:ok, record}
      {:aborted, x} -> {:error, x}
    end
  end
end
