defmodule Me.MixProject do
  use Mix.Project

  def project do
    [
      app: :me,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Me.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:httpoison, "~> 1.8"},
      {:solid, "~> 0.14.0"},
      {:mongodb_driver, "~> 1.0.0"}
    ]
  end
end
