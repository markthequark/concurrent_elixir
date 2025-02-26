defmodule Tickets.MixProject do
  use Mix.Project

  def project do
    [
      app: :tickets,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:lager, :logger],
      mod: {Tickets.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:lager, ">= 1.0.0"},
      {:broadway, "~> 1.0"},
      {:broadway_rabbitmq, "~> 0.7"},
      {:amqp, ">= 1.0.0"}
    ]
  end
end
