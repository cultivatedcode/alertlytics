defmodule Sitrep do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    slack_token = Application.get_env(:sitrep, Sitrep.Workers.Slack)[:token]
    IO.puts("token '#{slack_token}'")

    config_path = Application.get_env(:sitrep, Sitrep)[:config_path] || "/etc/sitrep/config.json"

    children = [
      worker(Sitrep.Workers.Config, [config_path]),
      worker(Sitrep.Workers.Alert, []),
      worker(Slack.Bot, [Sitrep.Workers.Slack, [], slack_token]),
      worker(Sitrep.MonitorSupervisor, []),
      worker(Sitrep.Workers.Bootstrap, [])
    ]

    opts = [strategy: :one_for_one, name: Sitrep.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
