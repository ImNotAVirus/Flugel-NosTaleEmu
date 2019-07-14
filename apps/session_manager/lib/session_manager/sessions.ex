defmodule SessionManager.Sessions do
  @moduledoc false

  import Ecto.Query, only: [from: 2]
  alias SessionManager.{Repo, Session}
  alias Ecto.Changeset

  @doc false
  @spec get_by_username(String.t()) :: term
  def get_by_username(username) when not is_nil(username) do
    from(s in Session, where: s.username == ^username)
    |> Repo.one()
  end

  @doc false
  @spec session_exists?(String.t()) :: boolean
  def session_exists?(username) when not is_nil(username) do
    username
    |> get_by_username()
    |> is_nil()
    |> Kernel.!()
  end

  @doc false
  @spec insert(map) :: {:ok, Session.t()} | term
  def insert(attrs) do
    %Session{}
    |> Session.changeset(attrs)
    |> do_insert()
  end

  @doc false
  @spec insert_if_not_exists(map) ::
          {:ok, Session.t()} | {:error, :already_exists} | {:error, Changeset.t()}
  def insert_if_not_exists(attrs) when is_map(attrs) do
    %Session{}
    |> Session.changeset(attrs)
    |> do_insert_if_not_exists()
  end

  #
  # Private functions
  #

  @doc false
  @spec do_insert(Changeset.t()) :: {:ok, Session.t()} | term
  defp do_insert(%Changeset{} = changeset) do
    SessionManager.Repo.insert(changeset)
  end

  @doc false
  @spec do_insert_if_not_exists(Changeset.t()) ::
          {:ok, Session.t()} | {:error, :already_exists} | {:error, Changeset.t()}
  defp do_insert_if_not_exists(%Changeset{valid?: false} = changeset), do: {:error, changeset}

  defp do_insert_if_not_exists(%Changeset{} = changeset) do
    username =
      changeset
      |> Changeset.apply_changes()
      |> Map.get(:username)

    case session_exists?(username) do
      false ->
        do_insert(changeset)

      true ->
        {:error, :already_exists}
    end
  end
end
