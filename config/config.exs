# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :yellr,
  ecto_repos: [Yellr.Repo]

# Configures the endpoint
config :yellr, YellrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RYY4sGKW/DcR0VNql7warCAIi3achDPdFUdwZ9HI72t/T9o0YqeFG5ZRlWE4J+N3",
  render_errors: [view: YellrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Yellr.PubSub, adapter: Phoenix.PubSub.PG2]

config :yellr, Oban, repo: Yellr.Repo, crontab: false, queues: [git: 1]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
