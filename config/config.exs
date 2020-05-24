# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :joken, default_signer: "secret2"

config :profiles, Profiles.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000]

config :profiles,
  app_secret_key: "secret",
  jwt_validity: 3306,
  api_host: "localhost",
  api_version: 2,
  api_prefix: "http",
  account_service_url: "https://elixir-account-service.azurewebsites.net"

config :profiles, Profiles.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "52LURLndjW",
  username: "52LURLndjW",
  password: "HGgKkQOQt7",
  hostname: "remotemysql.com"
#  database: "masina_visurilor_tale",
#  username: "root",
#  password: "",
#  hostname: "localhost"

config :profiles, ecto_repos: [Profiles.Repo]


# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :minimal_server, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:minimal_server, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
