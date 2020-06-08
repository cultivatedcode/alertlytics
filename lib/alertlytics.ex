defmodule Alertlytics do
  use Application
  require Logger

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
    Logger.debug("token '#{slack_token}'")

    config_path =
      case Application.get_env(:sitrep, Sitrep)[:config_path] do
        nil ->
          "/etc/alertlytics/config.json"

        "" ->
          "/etc/alertlytics/config.json"

        _ ->
          Application.get_env(:sitrep, Sitrep)[:config_path]
      end

    Logger.info("config_path: '#{config_path}'")

    children = [
      AlertlyticsWeb.Telemetry,
      {Phoenix.PubSub, name: Alertlytics.PubSub},
      {Alertlytics.Workers.Config, config_path},
      Alertlytics.Workers.Alert,
      # {Slack.Bot, [Alertlytics.Workers.Slack, [], slack_token]},
      Alertlytics.MonitorRegistry,
      Alertlytics.MonitorSupervisor,
      Alertlytics.ServiceStatus,
      Alertlytics.Workers.Bootstrap,
      AlertlyticsWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Alertlytics.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AlertlyticsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
