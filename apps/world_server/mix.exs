defmodule WorldServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :world_server,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {WorldServer, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elven_gard, github: "imnotavirus/elvengard_v2"}
    ]
  end
end
