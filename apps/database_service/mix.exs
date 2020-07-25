defmodule DatabaseService.MixProject do
  use Mix.Project

  def project do
    [
      app: :database_service,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DatabaseService.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Nedded for ecto_bitfield (force Ecto 3)
      {:ecto, "~> 3.2", override: true},
      {:ecto_sql, "~> 3.2"},
      {:postgrex, "~> 0.15"},
      {:ecto_enum, "~> 1.4"},
      {:ecto_bitfield, "~> 0.1.0"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
