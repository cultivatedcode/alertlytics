use Mix.Config

config :logger,
       :console,
       format: "$time $metadata[$level] $levelpad$message\n",
       metadata: [:request_id]

config :alertlytics, Alertlytics, config_path: System.get_env("CONFIG_PATH")
config :alertlytics, Alertlytics.Workers.Slack, token: System.get_env("SLACK_TOKEN")
config :slack, api_token: System.get_env("SLACK_TOKEN")
config :alertlytics, webhook: System.get_env("WEBHOOK_URL")

# Configures the endpoint
config :alertlytics, AlertlyticsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z4/TXUVNyBQthk46W8TXKZJJ9uIso602EGQNkJIKBANtTq12K/ZYxfIZp87IVPY/",
  render_errors: [view: AlertlyticsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Alertlytics.PubSub,
  live_view: [signing_salt: "UtkuunqQ"]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
