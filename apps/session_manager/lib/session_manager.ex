defmodule SessionManager do
  @moduledoc """
  Documentation for SessionManager.
  """

  alias SessionManager.Session

  @registry_name SessionManager.Registry

  @doc false
  @spec register_player(map) :: {:ok, Session.t()} | {:error, :already_exists}
  def register_player(data) do
    GenServer.call(@registry_name, {:register_player, data})
  end
end
