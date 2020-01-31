defmodule Yellr.Repo do
  use Ecto.Repo,
    otp_app: :yellr,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    if opts[:load_from_system_env] do
      {:ok, load_config_from_environment(opts)}
    else
      {:ok, opts}
    end
  end

  defp load_config_from_environment(config) do
    database_host = System.get_env("DATABASE_HOST") || raise "expected the DATABASE_HOST environment variable to be set"
    database_username = System.get_env("DATABASE_USER") || raise "expected the DATABASE_USER environment variable to be set"
    database_password = System.get_env("DATABASE_PASSWORD") || raise "expected the DATABASE_PASSWORD environment variable to be set"
    database_name = System.get_env("DATABASE_NAME") || "yellr_prod"
    database_port = System.get_env("DATABASE_PORT") || 5432
    config
      |> Keyword.put(:username, database_username)
      |> Keyword.put(:password, database_password)
      |> Keyword.put(:hostname, database_host)
      |> Keyword.put(:database, database_name)
      |> Keyword.put(:port, database_port)
      |> Keyword.delete(:load_from_system_env)
  end
end
