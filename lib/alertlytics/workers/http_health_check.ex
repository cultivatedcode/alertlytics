defmodule Alertlytics.Workers.HttpHealthCheck do
  use GenServer

  @moduledoc """
  Documentation for HttpHealthCheck.
  Checks http web services for the health status based on the services configured interval.
  """

  # Client

  @doc """
    Starts the http health check server for dynamic supervision.
  """
  def start_link([], service_config) do
    start_link(service_config)
  end

  @doc """
    Starts the http health check server.
  """
  def start_link(service_config) do
    IO.puts("Registering Http Health Check (#{service_config["health_check_url"]})")

    GenServer.start_link(__MODULE__, service_config,
      name: via_tuple(service_config["health_check_url"])
    )
  end

  def is_live(monitor_name) do
    GenServer.call(via_tuple(monitor_name), :is_live)
  end

  defp via_tuple(monitor_name) do
    {:via, Alertlytics.MonitorRegistry, {:health_check, monitor_name}}
  end

  # Server (Callbacks)

  def init(service_config) do
    delay = service_config["test_interval_in_minutes"] * 60_000
    IO.puts("- Checking every #{service_config["test_interval_in_minutes"]} minutes.")
    schedule_work(delay)
    {:ok, %{service_config: service_config, delay: delay, is_live: nil}}
  end

  def handle_info(:work, state) do
    url = state[:service_config]["health_check_url"]
    is_live_now = Alertlytics.Services.HttpService.check(url)

    Alertlytics.Workers.Alert.update_alert(
      state[:service_config],
      state[:is_live],
      is_live_now
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
end
