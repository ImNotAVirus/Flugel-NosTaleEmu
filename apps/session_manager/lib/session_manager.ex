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
  @spec get_by_id(String.t()) :: Session.t() | nil
  def get_by_id(id) do
    GenServer.call(@worker_name, {:get_by_id, id})
  end

  @doc false
  @spec register_player(map) :: {:ok, Session.t()} | {:error, :already_connected}
  def register_player(attrs) do
    GenServer.call(@worker_name, {:register_player, attrs})
  end

  @doc false
  @spec set_player_state(String.t(), atom) ::
          {:ok, Session.t()} | {:error, :unknown_user}
  def set_player_state(username, user_state) do
    GenServer.call(@worker_name, {:set_player_state, username, user_state})
  end

  @doc false
  @spec monitor_session(String.t()) :: {:ok, Session.t()} | {:error, :unknown_user}
  def monitor_session(username) do
    GenServer.call(@worker_name, {:monitor_session, username})
  end
end
