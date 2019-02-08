defmodule Sitrep.Workers.HttpHealthCheck do
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
    GenServer.start_link(__MODULE__, service_config)
  end

  # Server (Callbacks)

  def init(service_config) do
    delay = service_config["test_interval_in_minutes"] * 60_000
    schedule_work(delay)
    {:ok, %{service_config: service_config, delay: delay, is_live: nil}}
  end

  def handle_info(:work, state) do
    url = state[:service_config]["health_check_url"]
    is_live_now = Sitrep.Services.HttpService.check(url)

    Sitrep.Workers.Alert.optionally_send_alert(
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

  defp schedule_work(delay_in_minutes) do
    Process.send_after(self(), :work, delay_in_minutes)
  end
end
