defmodule DatabaseService.Player.Characters do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias DatabaseService.Repo
  alias DatabaseService.Player.Character

  @doc false
  @spec all_by_account(non_neg_integer) :: [Ecto.Schema.t(), ...]
  def all_by_account(account_id) do
    from(a in Character, where: a.account_id == ^account_id)
    |> Repo.all()
  end

  @doc false
  @spec get_by_name(String.t()) :: Ecto.Schema.t() | nil
  def get_by_name(name) do
    Repo.get_by(Character, name: name)
  end

  @doc false
  @spec get_by_account_and_slot(non_neg_integer, String.t()) :: Ecto.Schema.t() | nil
  def get_by_account_and_slot(account_id, slot) do
    from(a in Character, where: a.account_id == ^account_id and a.slot == ^slot)
    |> Repo.one()
  end

  @doc false
  @spec create(map) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  @spec create!(map) :: Ecto.Schema.t()
  def create!(attrs) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert!()
  end
end
