defmodule DatabaseService.Player.Characters do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias DatabaseService.Player.Character
  alias DatabaseService.Repo

  @doc false
  @spec all_by_account_id(pos_integer(), boolean()) :: [Character.t(), ...]
  def all_by_account_id(account_id, include_disabled \\ false)

  def all_by_account_id(account_id, true) do
    from(a in Character, where: a.account_id == ^account_id)
    |> Repo.all()
  end

  def all_by_account_id(account_id, false) do
    from(a in Character, where: a.account_id == ^account_id and a.disabled == false)
    |> Repo.all()
  end

  @doc false
  @spec get_by_name(String.t()) :: Character.t() | nil
  def get_by_name(name) do
    Repo.get_by(Character, name: name)
  end

  @doc false
  @spec get_by_account_id_and_slot(pos_integer(), non_neg_integer()) :: Character.t() | nil
  def get_by_account_id_and_slot(account_id, slot) do
    from(a in Character,
      where:
        a.account_id == ^account_id and
          a.slot == ^slot and a.disabled == false
    )
    |> Repo.one()
  end

  @doc false
  @spec create(map()) :: {:ok, Character.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  @spec create!(map()) :: Character.t()
  def create!(attrs) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert!()
  end

  @doc false
  @spec delete_by_account_id_and_slot(pos_integer(), non_neg_integer()) ::
          {:ok, Character.t()} | {:error, Ecto.Changeset.t()}
  def delete_by_account_id_and_slot(account_id, slot) do
    character = get_by_account_id_and_slot(account_id, slot)
    new_name = "[DELETED]##{character.name}##{generate_tag()}"
    attrs = %{disabled: true, name: new_name}

    character
    |> Character.disabled_changeset(attrs)
    |> Repo.update()
  end

  ## Private functions

  @doc false
  @spec generate_tag() :: String.t()
  defp generate_tag() do
    :rand.uniform(9999) |> Integer.to_string() |> String.pad_leading(4, "0")
  end
end
