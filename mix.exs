defmodule Sitrep.MixProject do
  use Mix.Project

  def project do
    [
      app: :sitrep,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Sitrep, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:remix, "~> 0.0.1", only: :dev},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
