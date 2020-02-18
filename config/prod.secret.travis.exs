# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :yellr, YellrWeb.Endpoint,
  secret_key_base: (System.get_env("HTTP_SECRET_KEY_BASE") || raise "SECRET KEY BASE UNSPECIFIED")

config :yellr, Yellr.Authentication.Guardian,
  issuer: "Yellr",
  secret_key: (System.get_env("JWT_SECRET_KEY") || raise "JWT SECRET KEY UNSPECIFIED")

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :yellr, YellrWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
