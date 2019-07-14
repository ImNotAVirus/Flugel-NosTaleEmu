defmodule SessionManager do
  @moduledoc """
  Documentation for SessionManager.
  """

  @doc false
  @spec register_player(map) :: non_neg_integer
  def register_player(state) do
    # Here, create ecto User schema from state and call DB
    # %Session{} |> Session.changeset(%{username: "test", password: "ok"}) |> SessionManager.Repo.insert()
  end
end
