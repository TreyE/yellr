use Mix.Config

# Configure your database
config :yellr, Yellr.Repo,
  database: "yellr_test",
  hostname: "localhost",
  username: "postgres",
  password: "",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :yellr, YellrWeb.Endpoint,
  http: [port: 4002],
  server: false

config :yellr, Yellr.Authentication.Guardian,
  issuer: "Yellr",
  secret_key: "rqvGULwGescBTkL8sgigX+AxL4m992vlrkNy7QkO1bifWuFEGQuNWBPS3kx2IBBf"

config :yellr, Oban, repo: Yellr.Repo, crontab: false, queues: false, prune: :disabled

config :junit_formatter,
  report_dir: "."

# Print only warnings and errors during test
config :logger, level: :warn
