import Config

#
# Get some env variables
#

pod_namespace =
  case System.fetch_env("POD_NAMESPACE") do
    {:ok, value} -> value
    _ -> "default"
  end

postgres_host =
  case System.fetch_env("POSTGRES_HOST") do
    {:ok, value} -> "#{value}.#{pod_namespace}.svc.cluster.local"
    _ -> "localhost"
  end

redis_host =
  case System.fetch_env("REDIS_HOST") do
    {:ok, value} -> "#{value}.#{pod_namespace}.svc.cluster.local"
    _ -> "localhost"
  end

service_name =
  case System.fetch_env("SERVICE_NAME") do
    {:ok, value} -> "#{value}.#{pod_namespace}.svc.cluster.local"
    _ -> "localhost"
  end

#
# Auto-discovery
#

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
  hostname: postgres_host

#
# Session manager part
#

config :session_manager,
  redis_host: redis_host

#
# World manager part
#

config :world_manager,
  redis_host: redis_host

#
# Channel server part
#

config :world_server,
  world_name: {:system, :string, "WORLD_NAME", "ElvenGard"},
  max_players: {:system, :integer, "CHANNEL_MAX_PLAYERS", 1_000},
  port: {:system, :integer, "CHANNEL_PORT", 5_000},
  ip: {:system, :string, "NODE_IP"}
