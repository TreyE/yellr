defmodule Yellr.MixProject do
  use Mix.Project

  def project do
    [
      app: :yellr,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test
      ],
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Yellr.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.12"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:oban, "1.0.0"},
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.14.0"},
      {:distillery, "~> 2.1"},
      {:guardian, "~> 1.2.1"},
      {:pbkdf2_elixir, "~> 1.0"},
      {:ex_doc, "~> 0.21"},
      {:excoveralls, "~> 0.10", only: :test},
      {:credo, "~> 1.1", only: :dev},
      {:junit_formatter, "~> 3.0", only: [:test]},
      {:credo_ex_coveralls_uncovered, git: "https://github.com/TreyE/credo_ex_coveralls_uncovered.git" , only: [:dev]},
      {:credo_report_card, git: "https://github.com/TreyE/credo_report_card.git" , only: [:dev]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp docs do
    [
      main: "development_status",
      extras: [
        "documentation/development_status.md",
        "GETTING_STARTED.md"
      ]
    ]
  end
end
