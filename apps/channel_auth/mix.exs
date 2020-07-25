defmodule ChannelAuth.MixProject do
  use Mix.Project

  def project do
    [
      app: :channel_auth,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {ChannelAuth.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elven_gard, github: "imnotavirus/elvengard_v2"},
      {:core, in_umbrella: true},
      {:database_service, in_umbrella: true},
      {:session_manager, in_umbrella: true, runtime: false}
    ]
  end
end
