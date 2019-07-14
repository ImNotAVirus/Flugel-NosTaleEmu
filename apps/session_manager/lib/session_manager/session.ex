defmodule SessionManager.Session do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  schema "sessions" do
    field(:username, :string)
    field(:password, :string)

    # :logged -> :in_lobby -> in_game
    field(:state, :string, default: "logged")

    timestamps()
  end

  def changeset(%Session{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:username, :password, :state])
    |> unique_constraint(:username)
    |> validate_required([:username, :password])
    |> validate_inclusion(:state, ["logged", "in_lobby", "in_game"])
  end
end
