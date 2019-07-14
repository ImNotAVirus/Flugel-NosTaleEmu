defmodule SessionManager.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:sessions) do
      add(:username, :string, size: 32, null: false)
      add(:password, :string, size: 128, null: false)
      add(:state, :string, size: 16, null: false)
      timestamps()
    end

    create(unique_index(:sessions, [:username]))
  end
end
