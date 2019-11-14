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
    {:ok, nil}
  end

  @impl true
  def handle_call({:register_player, attrs}, _from, state) do
    username = Map.fetch!(attrs, :username)
    session = Sessions.get_by_username(username)

    if is_nil(session) or session.state == :logged do
      {:reply, Sessions.insert(attrs), state}
    else
      {:reply, {:error, :already_connected}, state}
    end
  end

  @impl true
  def handle_call({:set_player_state, username, user_state}, _from, state)
      when is_valid_state(user_state) do
    case Sessions.update_state(username, user_state) do
      {nil, _} ->
        {:reply, {:error, :unknown_user}, state}

      {_, x} ->
        if user_state == :in_lobby, do: Sessions.set_ttl(username, :infinity)
        {:reply, {:ok, x}, state}
    end
  end

  @impl true
  def handle_call({:monitor_session, username}, from, state) do
    {pid, _} = from
    ref = Process.monitor(pid)

    case Sessions.update_monitor(username, ref) do
      {nil, _} ->
        Process.demonitor(ref)
        {:reply, {:error, :unknown_user}, state}

      {_, x} ->
        {:reply, {:ok, x}, state}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _object, reason}, state) do
    session = Sessions.delete_monitor(ref)
    username = Map.get(session || %{}, :username, "#unknown#")

    Logger.info("#{inspect(username)} is now disconnected (reason: #{inspect(reason)})")
    {:noreply, state}
  end
end
