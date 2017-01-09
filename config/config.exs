# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :get_your_nutrients,
  ecto_repos: [GetYourNutrients.Repo]

# Configures the endpoint
config :get_your_nutrients, GetYourNutrients.Endpoint,
  url: [host: "localhost"],
  http: [compress: true],
  secret_key_base: "m63LMN6uuy9PHRK0BqIGre2zCNk7RQyVV5wsBHvHWN02H17DzGOsrGhFr/+oQEPE",
  render_errors: [view: GetYourNutrients.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GetYourNutrients.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
