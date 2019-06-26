defmodule Flugel.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      default_release: :flugel,
      releases: releases(),

      # Docs
      name: "Flügel",
      source_url: "https://github.com/ImNotAVirus/Flugel-NosTaleEmu",
      # homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      docs: [
        # The main page in the docs
        main: "Flugel",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  defp releases do
    [
      flugel: [
        include_executables_for: [:unix],
        include_erts: Mix.env() == :prod,
        applications: [
          login_server: :permanent,
          world_server: :permanent
        ]
      ],
      login_server: [
        include_executables_for: [:unix],
        include_erts: Mix.env() == :prod,
        applications: [login_server: :permanent]
      ],
      world_server: [
        include_executables_for: [:unix],
        include_erts: Mix.env() == :prod,
        applications: [world_server: :permanent]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:edeliver, "~> 1.6.0"},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
