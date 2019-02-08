defmodule Alertlytics.MonitorSupervisor do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_monitor(service_config) do
    IO.puts("Adding #{service_config["name"]}")
    spec = {Alertlytics.Workers.HttpHealthCheck, service_config}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
