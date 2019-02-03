use Mix.Config

config :remix,
  escript: true,
  silent: true

config :sitrep, Sitrep, config_path: System.get_env("CONFIG_PATH")
