# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :eagle_eye,
  ecto_repos: [EagleEye.Repo]

# Configures the endpoint
config :eagle_eye, EagleEye.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pN1ifN+H+uhhGs8w7gJCdbHg1p75ylccqFMgVjFbHqN6Gn6esDIP1VXVAQ2KgYPr",
  render_errors: [view: EagleEye.ErrorView, accepts: ~w(html json)],
  pubsub: [name: EagleEye.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
