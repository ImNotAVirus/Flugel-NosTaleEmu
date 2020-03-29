defmodule :release_tasks do
  @moduledoc """
  Documentation for ReleaseTasks.
  """

  @doc false
  @spec migrate() :: any
  def migrate() do
    {:ok, _} = Application.ensure_all_started(:database_service)

    path_migrations = Application.app_dir(:database_service, "priv/repo/migrations")
    Ecto.Migrator.run(DatabaseService.Repo, path_migrations, :up, all: true)

    file_seeds = Application.app_dir(:database_service, "priv/repo/seeds.exs")
    Code.eval_file(file_seeds)

    :init.stop()
  end
end
