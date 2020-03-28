# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :logger, :console,
  level: :info,
  format: "[$time] $metadata[$level] $levelpad$message\n",
  metadata: [:application]

config :elven_gard,
  num_acceptors: 5,
  response_timeout: 3000

#
# Database configs
#

config :database_service, ecto_repos: [DatabaseService.Repo]

config :database_service, DatabaseService.Repo,
  database: "elvengard_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  template: "template0"

#
# Login server part
#

config :login_server,
  port: {:system, :integer, "PORT", 4002},
  client_version: {:system, :string, "CLIENT_VERSION", "0.9.3.3086"}

#
# Session manager part
#

config :session_manager, redis_host: "localhost"

#
# World manager part
#

config :world_manager, redis_host: "localhost"

#
# World server part
#

config :world_server,
  world_name: "ElvenGard",
  ip: "127.0.0.1",
  port: 5000,
  max_players: 500

# Override configs if prod
if Mix.env() != :test, do: import_config("#{Mix.env()}.exs")
