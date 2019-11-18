defmodule WorldManager.Worker do
  @moduledoc false

  use GenServer

  require Logger

  alias WorldManager.Channels

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## Genserver behaviour

  @impl true
  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, nil, {:continue, :init_redis}}
  end

  @impl true
  def terminate(_, _) do
    :timer.sleep(1000)
  end

  @impl true
  def handle_continue(:init_redis, nil) do
    redis_host = Application.get_env(:world_manager, :redis_host, "127.0.0.1")
    {:ok, conn} = Redix.start_link(host: redis_host)
    {:noreply, conn}
  end

  @impl true
  def handle_call({:register_channel, attrs}, _from, state) do
    {:reply, Channels.insert(state, attrs), state}
  end

  @impl true
  def handle_call({:all_channels}, _from, state) do
    {:reply, Channels.all(state), state}
  end

  @impl true
  def handle_call({:monitor_channel, world_id, channel_id}, from, state) do
    {pid, _} = from

    ref = Process.monitor(pid)
    res = Channels.set_monitor(state, world_id, channel_id, ref)

    {:reply, res, state}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _object, reason}, state) do
    {:ok, channel_key} = Channels.delete_monitored(state, ref)

    Logger.info(
      "Channel #{inspect(channel_key)} is now disconnected (reason: #{inspect(reason)})"
    )

    {:noreply, state}
  end
end
