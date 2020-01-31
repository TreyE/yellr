# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :yellr, YellrWeb.Endpoint,
  secret_key_base: "YOUR REAL KEY BASE HERE"

config :yellr, Yellr.Authentication.Guardian,
  issuer: "Yellr",
  secret_key: "YOUR REAL JWT SECRET HERE"

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :yellr, YellrWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
