import Config

#
# Auto-discovery
#

service_name = System.fetch_env!("SERVICE_NAME")

config :peerage,
  via: Peerage.Via.Dns,
  dns_name: service_name,
  app_name: "flugel"

#
# Database configs
#

config :database_service, DatabaseService.Repo,
  database: {:system, :string, "POSTGRES_DB", "localhost"},
  username: {:system, :string, "POSTGRES_USER", "localhost"},
  password: {:system, :string, "POSTGRES_PASSWORD", "localhost"},
  hostname: {:system, :string, "POSTGRES_HOST", "localhost"}

#
# Session manager part
#

config :session_manager, redis_host: {:system, :string, "REDIS_HOST", "localhost"}

#
# World manager part
#

config :world_manager, redis_host: {:system, :string, "REDIS_HOST", "localhost"}

#
# Channel server part
#

config :world_server,
  world_name: {:system, :string, "WORLD_NAME", "ElvenGard"},
  port: {:system, :integer, "CHANNEL_PORT", 5_000},
  max_players: {:system, :integer, "CHANNEL_MAX_PLAYERS", 1_000},
  ip: {:system, :string, "KUBERNETES_HOST"}
