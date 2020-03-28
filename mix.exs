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
        quiet: true,
        applications: [
          session_manager: :load,
          world_manager: :load,
          login_server: :permanent,
          world_server: :permanent
        ]
      ],
      login_service: [
        include_executables_for: [:unix],
        include_erts: Mix.env() == :prod,
        quiet: true,
        applications: [
          session_manager: :load,
          world_manager: :load,
          login_server: :permanent
        ]
      ],
      channel_service: [
        include_executables_for: [:unix],
        include_erts: Mix.env() == :prod,
        quiet: true,
        applications: [
          session_manager: :load,
          world_manager: :load,
          world_server: :permanent
        ]
      ],
      session_manager: [
        include_executables_for: [:unix],
        include_erts: Mix.env() == :prod,
        quiet: true,
        applications: [session_manager: :permanent]
      ],
      world_manager: [
        include_executables_for: [:unix],
        include_erts: Mix.env() == :prod,
        quiet: true,
        applications: [world_manager: :permanent]
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
      {:ex_doc, "~> 0.21.2", only: :dev, runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
