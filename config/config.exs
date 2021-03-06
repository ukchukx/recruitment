# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :recruitment,
  ecto_repos: [Recruitment.Repo],
  verification_url: "localhost/verify.php"

# Configures the endpoint
config :recruitment, RecruitmentWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "or0jpy8qMXpY2be/vi1oESpqeJH5iI5kmYRwbjx5soREw8j2tpXFWtp0wF3EuORd",
  render_errors: [view: RecruitmentWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Recruitment.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id, :request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
