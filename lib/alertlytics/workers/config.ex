defmodule Alertlytics.Workers.Config do
  use GenServer
  require Logger

  @moduledoc """
  Documentation for Config.
  Provides access to the config for services to monitor.
  """

  # Client

  @doc """
    Starts the config server.
  """
  def start_link(config_file_path, name \\ __MODULE__) do
    Logger.info("Loading config file '#{config_file_path}'.")

    if File.exists?(config_file_path) do
      GenServer.start_link(__MODULE__, [config_file_path], name: name)
    else
      {:ok, working_dir} = File.cwd()
      raise "Error #{config_file_path} not found in #{working_dir}"
    end
  end

  def child_spec(config_file_path) do
    Supervisor.Spec.worker(__MODULE__, [config_file_path])
  end

  @doc """
    Returns the slack channel to use for alerts.
  """
  def channel do
    GenServer.call(__MODULE__, {:channel})
  end

  @doc """
    Returns a list of service configurations from the config file.
  """
  def services do
    GenServer.call(__MODULE__, {:services})
  end

  # Server (Callbacks)

  @impl true
  def init(file_path) do
    {:ok, body} = File.read(file_path)
    {:ok, json} = Poison.decode(body)
    {:ok, json}
  end

  @impl true
  def handle_call({:services}, _from, json) do
    services = json["services"]
    {:reply, services, json}
  end

  @impl true
  def handle_call({:channel}, _from, json) do
    channel = json["channel"]
    {:reply, channel, json}
  end
end
