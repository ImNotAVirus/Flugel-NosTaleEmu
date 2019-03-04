defmodule Flugel.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Flügel",
      source_url: "https://github.com/ImNotAVirus/Flugel-NostaleEmu",
      # homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      docs: [
        # The main page in the docs
        main: "Flugel",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
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
      {:distillery, "~> 2.0"},
      {:ex_doc, "~> 0.19.0", only: :dev, runtime: false},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false}
    ]
  end
end
