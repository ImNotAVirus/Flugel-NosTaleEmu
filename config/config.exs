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
  level: :debug,
  format: "$time $metadata[$level] $message\n",
  metadata: [:application]

config :elven_gard,
  num_acceptors: 5,
  response_timeout: 3000

config :login_server,
  port: System.get_env("LOGIN_PORT", "4002") |> String.to_integer(),
  client_version: System.get_env("CLIENT_VERSION", "0.9.3.3086")

config :world_server,
  port: System.get_env("WORLD_PORT", "5000") |> String.to_integer()

#
# Session manager part
#

# Multilevel Cache – wrapper for L1 and L2 caches
config :session_manager, SessionManager.Cache,
  cache_model: :inclusive,
  levels: [SessionManager.Cache.L1, SessionManager.Cache.L2]

# L1 Cache
config :session_manager, SessionManager.Cache.L1,
  gc_interval: 86_400

# L2 Cache
config :session_manager, SessionManager.Cache.L2,
  local: SessionManager.Cache.L2.Primary,
  hash_slot: SessionManager.Cache.JumpingHashSlot

# Internal local cache used by SessionManager.Cache.L2
config :session_manager, SessionManager.Cache.L2.Primary,
  gc_interval: 86_400
