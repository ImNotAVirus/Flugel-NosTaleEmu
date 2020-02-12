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
  format: "$time $metadata[$level] $message\n",
  metadata: [:application]

config :elven_gard,
  num_acceptors: 15,
  response_timeout: 1500
