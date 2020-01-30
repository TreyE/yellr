defmodule Yellr.Repo do
  use Ecto.Repo,
    otp_app: :yellr,
    adapter: Ecto.Adapters.Postgres
end
