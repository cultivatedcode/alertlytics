use Mix.Config

config :remix,
  escript: true,
  silent: true

config :sitrep, Sitrep, config_path: System.get_env("CONFIG_PATH")
config :sitrep, Sitrep.Workers.Slack, token: System.get_env("SLACK_TOKEN")
config :slack, api_token: System.get_env("SLACK_TOKEN")

# import_config "#{Mix.env}.exs"
