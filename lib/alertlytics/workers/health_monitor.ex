defmodule Alertlytics.Workers.HealthMonitor do
  use GenServer
  require Logger

  @moduledoc """
  Documentation for HealthMonitor.
  Generic health monitor that can monitor any type of service based on a polling interval.
  """

  # Client

  @doc """
    Starts the health monitor server for dynamic supervision.
  """
  def start_link([], service_config) do
    start_link(service_config)
  end

  @doc """
    Starts the health monitor server.
  """
  def start_link(service_config) do
    Logger.info(
      " - Registering Health Monitor (name: #{service_config["name"]}, type: #{
        service_config["type"]
      })"
    )

    GenServer.start_link(__MODULE__, service_config,
      name: via_tuple("#{service_config["type"]}-#{service_config["name"]}")
    )
  end

  @doc """
    Check if the service is live.
  """
  def is_live(monitor_name) do
    GenServer.call(via_tuple(monitor_name), :is_live)
  end

  defp via_tuple(monitor_name) do
    {:via, Alertlytics.MonitorRegistry, {:health_check, monitor_name}}
  end

  # Server (Callbacks)

  def init(service_config) do
    delay = service_config["test_interval_in_seconds"] * 1_000

    Logger.info(
      "- '#{service_config["name"]}' checking every #{service_config["test_interval_in_seconds"]} seconds."
    )

    schedule_work(delay)
    {:ok, %{service_config: service_config, delay: delay, is_live: nil}}
  end

  def handle_info(:work, state) do
    config = state[:service_config]["config"]
    monitor_module = build_monitor_module(state[:service_config]["type"])
    {duration, is_live_now} = :timer.tc(fn -> monitor_module.check(config) end)

    Alertlytics.ServiceStatus.update(state[:service_config]["name"], is_live_now)

    Alertlytics.Workers.Alert.update_alert(
      state[:service_config],
      state[:is_live],
      is_live_now,
      duration
    )

    schedule_work(state[:delay])

    {:noreply,
     %{service_config: state[:service_config], delay: state[:delay], is_live: is_live_now}}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  def handle_call(:is_live, _from, state) do
    {:reply, state[:is_live], state}
  end

  defp schedule_work(delay_in_minutes) do
    Process.send_after(self(), :work, delay_in_minutes)
  end

  defp build_monitor_module(type) do
    case type do
      "http" -> Alertlytics.Adapters.HttpAdapter
      "rabbit_mq" -> Alertlytics.Adapters.RabbitMqAdapter
      _ -> Alertlytics.Adapters.HttpAdapter
    end
  end
end
