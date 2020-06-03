defmodule Alertlytics.MonitorSupervisor do
  use DynamicSupervisor
  require Logger

  @moduledoc """
  Documentation for MonitorSupervisor.
  The supervisor of all monitoring processes.  These are spawned based on the config passed in to the application.
  """

  @doc """
    Starts the supervisor.
  """
  def start_link do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
    Add a service to be monitored.
  """
  def add_monitor(service_config) do
    Logger.info("-Adding '#{service_config["name"]}'")
    spec = {Alertlytics.Workers.HttpHealthCheck, service_config}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @doc """
    Initialization of the strategy to use for the child processes
  """
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
