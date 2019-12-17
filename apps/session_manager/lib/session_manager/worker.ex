defmodule SessionManager.Worker do
  @moduledoc false

  use GenServer

  require Logger

  import SessionManager.Session, only: [is_valid_state: 1]

  alias SessionManager.Sessions

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## Genserver behaviour

  @impl true
  def init(_) do
    {:ok, nil, {:continue, :init_redis}}
  end

  @impl true
  def handle_continue(:init_redis, nil) do
    redis_host = Application.get_env(:session_manager, :redis_host, "127.0.0.1")
    {:ok, conn} = Redix.start_link(host: redis_host)
    {:noreply, conn}
  end

  @impl true
  def handle_call({:get_by_name, username}, _from, state) do
    {:reply, Sessions.get_by_username(state, username), state}
  end

  @impl true
  def handle_call({:register_player, attrs}, _from, state) do
    username = Map.fetch!(attrs, :username)
    session = Sessions.get_by_username(state, username)

    if is_nil(session) or session.state == :logged do
      {:reply, Sessions.insert(state, attrs), state}
    else
      {:reply, {:error, :already_connected}, state}
    end
  end

  @impl true
  def handle_call({:set_player_state, username, user_state}, _from, state)
      when is_valid_state(user_state) do
    case Sessions.update_state(state, username, user_state) do
      {:error, _} = x ->
        {:reply, x, state}

      {:ok, _} = x ->
        if user_state == :in_lobby, do: {:ok, _} = Sessions.set_ttl(state, username, :infinity)
        {:reply, x, state}
    end
  end

  @impl true
  def handle_call({:monitor_session, username}, from, state) do
    {pid, _} = from
    ref = Process.monitor(pid)

    case Sessions.set_monitor(state, username, ref) do
      {:error, _} = x ->
        Process.demonitor(ref)
        {:reply, x, state}

      {:ok, _} = x ->
        {:reply, x, state}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _object, reason}, state) do
    {:ok, username} = Sessions.delete_monitored(state, ref)

    Logger.info("#{inspect(username)} is now disconnected (reason: #{inspect(reason)})")
    {:noreply, state}
  end
end
