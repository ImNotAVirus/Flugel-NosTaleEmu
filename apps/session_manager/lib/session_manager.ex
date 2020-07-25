defmodule SessionManager do
  @moduledoc """
  Documentation for SessionManager.
  """

  alias SessionManager.Session

  @worker_name SessionManager.Worker

  @doc false
  @spec get_by_name(String.t()) :: Session.t() | nil
  def get_by_name(username) do
    GenServer.call(@worker_name, {:get_by_name, username})
  end

  @doc false
  @spec get_by_id(pos_integer()) :: Session.t() | nil
  def get_by_id(id) do
    GenServer.call(@worker_name, {:get_by_id, id})
  end

  @doc false
  @spec register_player(map) :: {:ok, Session.t()} | {:error, any()}
  def register_player(attrs) do
    GenServer.call(@worker_name, {:register_player, attrs})
  end

  @doc false
  @spec set_player_state(String.t(), Session.state()) :: {:ok, Session.t()} | {:error, any()}
  def set_player_state(username, user_state) do
    GenServer.call(@worker_name, {:set_player_state, username, user_state})
  end

  @doc false
  @spec monitor_session(String.t(), pid()) :: {:ok, Session.t()} | {:error, any()}
  def monitor_session(username, from \\ nil)
  def monitor_session(username, nil), do: monitor_session(username, self())

  def monitor_session(username, from) do
    GenServer.call(@worker_name, {:monitor_session, username, from})
  end
end
