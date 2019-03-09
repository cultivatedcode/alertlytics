defmodule Alertlytics do
  use Application

  @moduledoc """
  Documentation for Alertlytics.
  Alertlytics application main entry point.
  """

  @doc """
    Starts the alertlytics application and starts the monitoring engine..
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    slack_token = Application.get_env(:alertlytics, Alertlytics.Workers.Slack)[:token]
    IO.puts("token '#{slack_token}'")

    config_path =
      case Application.get_env(:sitrep, Sitrep)[:config_path] do
        nil ->
          "/etc/alertlytics/config.json"

        "" ->
          "/etc/alertlytics/config.json"

        _ ->
          Application.get_env(:sitrep, Sitrep)[:config_path]
      end

    IO.puts("config_path: '#{config_path}'")

    children = [
      worker(Alertlytics.Workers.Config, [config_path]),
      worker(Alertlytics.Workers.Alert, []),
      worker(Slack.Bot, [Alertlytics.Workers.Slack, [], slack_token]),
      worker(Alertlytics.MonitorRegistry, []),
      worker(Alertlytics.MonitorSupervisor, []),
      worker(Alertlytics.Workers.Bootstrap, [])
    ]

    opts = [strategy: :one_for_one, name: Alertlytics.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
