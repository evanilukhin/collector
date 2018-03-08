# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :collector, CollectorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ADXqoIkS9biJhf8EC1Kzs/7b1S3GXByzM27V/n2EEStMNakVLi9oL8RndB4k7Bfm",
  render_errors: [view: CollectorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Collector.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
