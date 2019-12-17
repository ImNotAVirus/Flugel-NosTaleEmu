defmodule DatabaseService.Player.Accounts do
  @moduledoc false

  alias DatabaseService.Repo
  alias DatabaseService.Player.Account

  @doc false
  @spec get_by_name(String.t()) :: Ecto.Schema.t() | nil
  def get_by_name(username) do
    Repo.get_by(Account, username: username)
  end

  @doc false
  @spec create(map) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  @spec create!(map) :: Ecto.Schema.t()
  def create!(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert!()
  end
end
