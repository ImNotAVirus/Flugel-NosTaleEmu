defmodule DatabaseService.Player.Accounts do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias DatabaseService.Repo
  alias DatabaseService.Player.Account

  @doc false
  @spec get_by_id(non_neg_integer) :: Ecto.Schema.t() | nil
  def get_by_id(id), do: Repo.get(Account, id)

  @doc false
  @spec authentificate(String.t(), String.t()) :: Ecto.Schema.t() | nil
  def authentificate(username, password) do
    from(u in Account, where: u.username == ^username and u.password == ^password)
    |> Repo.one()
  end

  @doc false
  @spec create_account(map) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_account(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  @spec create_account!(map) :: Ecto.Schema.t()
  def create_account!(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert!()
  end
end
