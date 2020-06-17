# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

config :alertlytics, Alertlytics, config_path: System.fetch_env("CONFIG_PATH")
config :alertlytics, Alertlytics.Workers.Slack, token: System.fetch_env("SLACK_TOKEN")
config :slack, api_token: System.fetch_env("SLACK_TOKEN")

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.

config :alertlytics, AlertlyticsWeb.Endpoint,
  http: [port: 4000],
  code_reloader: false,
  server: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, level: :info, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
