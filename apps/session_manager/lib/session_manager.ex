defmodule SessionManager do
  @moduledoc """
  Documentation for SessionManager.
  """

  alias SessionManager.Session

  @worker_name {:svc, __MODULE__}

  @doc false
  @spec get_by_name(String.t()) :: Session.t() | nil
  def get_by_name(username) do
    @worker_name
    |> :pg2.get_closest_pid()
    |> GenServer.call({:get_by_name, username})
  end

  @doc false
  @spec register_player(map) :: {:ok, Session.t()} | {:error, :already_connected}
  def register_player(attrs) do
    @worker_name
    |> :pg2.get_closest_pid()
    |> GenServer.call({:register_player, attrs})
  end

  @doc false
  @spec set_player_state(String.t(), atom) ::
          {:ok, Session.t()} | {:error, :unknown_user}
  def set_player_state(username, user_state) do
    @worker_name
    |> :pg2.get_closest_pid()
    |> GenServer.call({:set_player_state, username, user_state})
  end

  @doc false
  @spec monitor_session(String.t()) :: {:ok, Session.t()} | {:error, :unknown_user}
  def monitor_session(username) do
    @worker_name
    |> :pg2.get_closest_pid()
    |> GenServer.call({:monitor_session, username})
  end
end
