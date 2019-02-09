use Mix.Config

config :alertlytics, Alertlytics, config_path: "${CONFIG_PATH}"
config :alertlytics, Alertlytics.Workers.Slack, token: "${SLACK_TOKEN}"
config :slack, api_token: "${SLACK_TOKEN}"

# import_config "#{Mix.env}.exs"
