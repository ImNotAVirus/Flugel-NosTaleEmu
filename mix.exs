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
          login_frontend: :permanent,
          channel_frontend: :permanent
        ]
      ],
      login_frontend: [
        include_executables_for: [:unix],
        include_erts: Mix.env() == :prod,
        applications: [login_frontend: :permanent]
      ],
      channel_frontend: [
        include_executables_for: [:unix],
        include_erts: Mix.env() == :prod,
        applications: [channel_frontend: :permanent]
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
