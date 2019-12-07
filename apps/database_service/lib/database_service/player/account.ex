defmodule DatabaseService.Player.Account do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import EctoBitfield

  alias DatabaseService.Enums.LanguageKey
  alias DatabaseService.Player.Account

  #
  # GameMaster: can ban, kick, mute, customs commands, etc....
  # Administrator: can use "system" commands like kill services, reboots servers, ...
  #
  defbitfield AuthorityType, [:game_master, :administrator]

  schema "accounts" do
    field :username, :string
    field :password, :string
    field :authority, Account.AuthorityType
    field :language, LanguageKey

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:username, :password, :authority, :language])
    |> unique_constraint(:username)
    |> validate_required([:username, :password])
  end
end
