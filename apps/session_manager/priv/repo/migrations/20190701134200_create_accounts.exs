defmodule SessionManager.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  @doc false
	def change do
		create table(:accounts) do
			add(:username, :string, size: 32, null: false)
			add(:password, :string, size: 128, null: false)
			add(:authority, :integer, default: 0)
			add(:email, :string, null: false)

			timestamps()
		end

		create(unique_index(:accounts, [:username]))
  end
end
