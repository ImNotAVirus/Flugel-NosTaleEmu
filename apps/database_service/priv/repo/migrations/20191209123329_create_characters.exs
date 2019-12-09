defmodule DatabaseService.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
			add :account_id, references(:accounts), null: false
      add :name, :string, size: 14, null: false
			add :slot, :int2, null: false

      add :class, :int2, default: 0, null: false
      add :faction, :int2, default: 0, null: false
			add :gender, :int2, null: false
      add :hair_color, :int2, null: false
      add :hair_style, :int2, null: false

      add :map_id, :int2, null: false
      add :map_x, :int2, null: false
      add :map_y, :int2, null: false

      add :hp, :int4, null: false
      add :mp, :int4, null: false
      add :gold, :int8, default: 0, null: false
      add :biography, :string, default: "Hi!", null: false

      add :level, :int2, default: 1, null: false
      add :job_level, :int2, default: 1, null: false
      add :hero_level, :int2, default: 0, null: false
      add :level_xp, :int4, default: 0, null: false
      add :job_level_xp, :int4, default: 0, null: false
      add :hero_level_xp, :int4, default: 0, null: false

      add :sp_point, :int4, default: 10_000, null: false
      add :sp_additional_point, :int4, default: 50_000, null: false
      add :rage_point, :int4, default: 0, null: false
      add :max_mate_count, :int2, default: 10, null: false

      add :reputation, :int4, default: 0, null: false
      add :dignity, :int2, default: 100, null: false
      add :compliment, :int2, default: 0, null: false

      add :act4_dead, :int4, default: 0, null: false
      add :act4_kill, :int4, default: 0, null: false
      add :act4_points, :int4, default: 0, null: false
      add :arena_winner, :boolean, default: false, null: false
      add :talent_win, :int4, default: 0, null: false
      add :talent_lose, :int4, default: 0, null: false
      add :talent_surrender, :int4, default: 0, null: false
      add :master_points, :int4, default: 0, null: false
      add :master_ticket, :int4, default: 0, null: false

      add :miniland_intro, :string, default: "Welcome!", null: false
      add :miniland_state, :int2, default: 0, null: false
      add :miniland_makepoints, :int2, default: 2000, null: false

      add :game_options, :int8, default: 0, null: false

			timestamps()
		end

    create unique_index(:characters, [:name])
  end
end
