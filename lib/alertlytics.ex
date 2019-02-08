defmodule Alertlytics do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    slack_token = Application.get_env(:alertlytics, Alertlytics.Workers.Slack)[:token]
    IO.puts("token '#{slack_token}'")

    config_path = Application.get_env(:alertlytics, Alertlytics)[:config_path] || "/etc/alertlytics/config.json"

    children = [
      worker(Alertlytics.Workers.Config, [config_path]),
      worker(Alertlytics.Workers.Alert, []),
      worker(Slack.Bot, [Alertlytics.Workers.Slack, [], slack_token]),
      worker(Alertlytics.MonitorSupervisor, []),
      worker(Alertlytics.Workers.Bootstrap, [])
    ]

    opts = [strategy: :one_for_one, name: Alertlytics.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
