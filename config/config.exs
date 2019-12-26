# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :norte,
  ecto_repos: [Norte.Repo]

# Configures the endpoint
config :norte, NorteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gfJ0Ecb7CjaPXp+MQHYMmxM8oFw7Bwk3Uqp95x9AzGqK834NBwrUyadnhsqqLKjd",
  render_errors: [view: NorteWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Norte.PubSub, adapter: Phoenix.PubSub.PG2]

# Guardian config
config :norte, Norte.Guardian,
  issuer: "norte",
  secret_key: "Bkv4PzvhCk0wpt2QmjJE1pPGSsSkKvazwgEAPWtqxrCe9ZRvOwEOCPsLQ92OOP1w"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
