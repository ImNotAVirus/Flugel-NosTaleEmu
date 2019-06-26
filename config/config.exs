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

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

config :elven_gard,
  num_acceptors: 5,
  response_timeout: 3000

config :login_server,
  port: System.get_env("LOGIN_PORT", "4002") |> String.to_integer(),
  client_version: System.get_env("CLIENT_VERSION", "0.9.3.3086")

config :world_server,
  port: System.get_env("WORLD_PORT", "5000") |> String.to_integer()
