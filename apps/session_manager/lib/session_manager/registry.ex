defmodule SessionManager.Registry do
  @moduledoc false

  use GenServer

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
end
