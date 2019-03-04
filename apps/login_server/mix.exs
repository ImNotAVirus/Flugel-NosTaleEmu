defmodule LoginServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :login_server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {LoginServer, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {
        :elven_gard,
        git: "https://github.com/ImNotAVirus/ElvenGard_V2.git",
        branch: :"refactoring-only_elven"
      }
    ]
  end
end
