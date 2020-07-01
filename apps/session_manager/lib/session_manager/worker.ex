defmodule SessionManager.Worker do
  @moduledoc false

  use GenServer

  require Logger

  import SessionManager.Session

  alias SessionManager.{Session, Sessions}

  @doc false
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## Public API

  @doc """
  Clean expired keys
  """
  @spec clean_expired_keys(atom()) :: :ok
  def clean_expired_keys(table) do
    {:ok, expire_keys} = Sessions.clean_expired_keys(table) |> IO.inspect()
    Logger.debug("Table `#{table}`: cleared #{length(expire_keys)} key(s)")
  end

  ## Genserver behaviour

  @impl true
  def init(_) do
    {:ok, nil, {:continue, :init_mnesia}}
  end

  @impl true
  def handle_continue(:init_mnesia, nil) do
    :ok = :mnesia.start()

    session_table_name = Session.mnesia_table_name()
    session_attributes = Session.mnesia_attributes()
    {:atomic, :ok} = :mnesia.create_table(session_table_name, attributes: session_attributes)
    {:atomic, :ok} = :mnesia.add_table_index(session_table_name, :id)
    {:atomic, :ok} = :mnesia.add_table_index(session_table_name, :monitor)

    ai_attributes = [:table, :value]

    case :mnesia.create_table(:auto_increment_counter, attributes: ai_attributes) do
      {:atomic, :ok} -> :ok
      {:aborted, {:already_exists, :auto_increment_counter}} -> :ok
      _ -> raise "unable to create the `auto_increment_counter` table"
    end

    # Init counter table
    :mnesia.dirty_update_counter(:auto_increment_counter, session_table_name, 0)

    # Autoclean expired keys
    :timer.apply_interval(30_000, __MODULE__, :clean_expired_keys, [session_table_name])

    {:noreply, nil}
  end

  @impl true
  def handle_call({:get_by_name, username}, _from, state) do
    {:reply, Sessions.get_by_username(username), state}
  end

  @impl true
  def handle_call({:get_by_id, id}, _from, state) do
    {:reply, Sessions.get_by_id(id), state}
  end

  @impl true
  def handle_call({:register_player, attrs}, _from, state) do
    username = Map.fetch!(attrs, :username)
    record = Sessions.get_by_username(username)

    if is_nil(record) or session(record, :state) in [:logged, :disconnected] do
      {:reply, Sessions.insert(attrs), state}
    else
      {:reply, {:error, :already_connected}, state}
    end
  end

  @impl true
  def handle_call({:set_player_state, username, user_state}, _from, state) do
    case Sessions.update_state(username, user_state) do
      {:error, _} = x ->
        {:reply, x, state}

      {:ok, _} = x ->
        if user_state == :in_lobby, do: {:ok, _} = Sessions.set_ttl(username, :infinity)
        {:reply, x, state}
    end
  end

  @impl true
  def handle_call({:monitor_session, username}, from, state) do
    {pid, _} = from
    ref = Process.monitor(pid)

    case Sessions.set_monitor(username, ref) do
      {:error, _} = x ->
        Process.demonitor(ref)
        {:reply, x, state}

      {:ok, _} = x ->
        {:reply, x, state}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _object, reason}, state) do
    {:ok, username} = Sessions.delete_monitored(ref)

    Logger.info("#{inspect(username)} is now disconnected (reason: #{inspect(reason)})")
    {:noreply, state}
  end
end
