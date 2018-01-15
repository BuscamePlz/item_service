# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :items_service,
  ecto_repos: [ItemsService.Repo]

# Configures the endpoint
config :items_service, ItemsServiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9zuDnI7mQGKe8qoYch1yiGk/Q2siwagqlhUQTPOL+h04kfUMOhdzTh5P2vOhCahB",
  render_errors: [view: ItemsServiceWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ItemsService.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, {:awscli, "default", 30}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, {:awscli, "default", 30}, :instance_role]

config :arc,
  storage: Arc.Storage.Local

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
