defmodule WorldManager.Worker do
  @moduledoc false

  use GenServer

  import WorldManager.Channel, only: [channel: 2]

  require Logger

  alias WorldManager.{Channel, Channels, World}

  @doc false
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## Genserver behaviour

  @impl true
  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, nil, {:continue, :init_mnesia}}
  end

  @impl true
  def handle_continue(:init_mnesia, nil) do
    :ok = :mnesia.start()

    world_table_name = World.mnesia_table_name()
    world_attributes = World.mnesia_attributes()
    {:atomic, :ok} = :mnesia.create_table(world_table_name, attributes: world_attributes)

    channel_table_name = Channel.mnesia_table_name()
    channel_attributes = Channel.mnesia_attributes()
    {:atomic, :ok} = :mnesia.create_table(channel_table_name, attributes: channel_attributes)
    {:atomic, :ok} = :mnesia.add_table_index(channel_table_name, :monitor)

    ai_attributes = [:table, :value]

    case :mnesia.create_table(:auto_increment_counter, attributes: ai_attributes) do
      {:atomic, :ok} -> :ok
      {:aborted, {:already_exists, :auto_increment_counter}} -> :ok
      _ -> raise "unable to create the `auto_increment_counter` table"
    end

    # Init counter table
    :mnesia.dirty_update_counter(:auto_increment_counter, world_table_name, 0)
    :mnesia.dirty_update_counter(:auto_increment_counter, channel_table_name, 0)

    {:noreply, nil}
  end

  @impl true
  def handle_call({:register_channel, attrs}, _from, state) do
    {:reply, Channels.insert(attrs), state}
  end

  @impl true
  def handle_call({:all_channels}, _from, state) do
    {:reply, Channels.all(), state}
  end

  @impl true
  def handle_call({:monitor_channel, world_id, channel_id}, from, state) do
    {pid, _} = from

    ref = Process.monitor(pid)
    result = Channels.set_monitor(world_id, channel_id, ref)

    {:reply, result, state}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _object, reason}, state) do
    {:ok, record} = Channels.delete_monitored(ref)
    id = channel(record, :id)

    Logger.info("Channel #{inspect(id)} is now disconnected\
     (reason: #{inspect(reason)})")

    {:noreply, state}
  end
end
