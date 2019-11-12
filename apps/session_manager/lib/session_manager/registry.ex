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
  def handle_call({:register_player, data}, _from, state) do
    res = Sessions.insert_if_not_exists(data)
    {:reply, res, state}
  end
end
