defmodule Alertlytics.Workers.Bootstrap do
  use GenServer
  require Logger

  @moduledoc """
  Documentation for Bootstrap.
  Bootstrap process which starts all of the monitoring.
  """

  # Client

  def child_spec(_) do
    Supervisor.Spec.worker(__MODULE__, [])
  end

  @doc """
    Starts the config server.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Server (Callbacks)

  def init(init_arg) do
    services = Alertlytics.Workers.Config.services()
    Logger.info("Initializing monitoring.")
    Logger.info("------------------------")

    Enum.each(services, fn service ->
      Alertlytics.MonitorSupervisor.add_monitor(service)
    end)

    {:ok, true}
  end
end
