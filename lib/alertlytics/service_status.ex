defmodule Alertlytics.ServiceStatus do
  use GenServer

  @moduledoc """
  Documentation for MonitorSupervisor.
  The supervisor of all monitoring processes.  These are spawned based on the config passed in to the application.
  """

  # API

  @topic inspect(__MODULE__)

  @doc """
    Child spec for this module.
  """
  def child_spec(_) do
    Supervisor.Spec.worker(__MODULE__, [])
  end

  @doc """
    Starts the service status.
  """
  def start_link(name \\ :service_status) do
    GenServer.start_link(__MODULE__, nil, name: name)
  end

  @doc """
    Get the status of all services.
  """
  def all() do
    GenServer.call(:service_status, {:all})
  end

  @doc """
    Get the status of a specific service.
  """
  def get(name) do
    GenServer.call(:service_status, {:get, name})
  end

  @doc """
    Updates the service status of a specific service.
  """
  def update(name, is_live) do
    GenServer.call(:service_status, {:update, name, is_live})
  end

  @doc """
    Subscribes to the topic for pushing any changes in status.
  """
  def subscribe do
    Phoenix.PubSub.subscribe(Alertlytics.PubSub, @topic)
  end

  # def subscribe(name) do
  #   Phoenix.PubSub.subscribe(Alertlytics.PubSub, @topic <> "#{name}")
  # end

  # SERVER

  def init(_) do
    {:ok, Map.new()}
  end

  def handle_call({:all}, _from, state) do
    services =
      Enum.map(state, fn {key, value} ->
        Map.merge(%{name: key}, value)
      end)

    {:reply, services, state}
  end

  def handle_call({:get, name}, _from, state) do
    {:reply, Map.get(state, name, :undefined), state}
  end

  def handle_call({:update, name, is_live}, _from, state) do
    notify_subscribers([:update])

    case Map.get(state, name) do
      nil ->
        {:reply, :yes,
         Map.put(state, name, %{is_live: is_live, last_checked: DateTime.utc_now()})}

      _ ->
        {:reply, :yes,
         Map.put(state, name, %{is_live: is_live, last_checked: DateTime.utc_now()})}
    end
  end

  defp notify_subscribers(event) do
    Phoenix.PubSub.broadcast(Alertlytics.PubSub, @topic, {__MODULE__, event})
    {:ok, event}
  end
end
