defmodule Alertlytics.ServiceStatus do
  use GenServer

  # API

  def child_spec(_) do
    Supervisor.Spec.worker(__MODULE__, [])
  end

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :service_status)
  end

  def all() do
    GenServer.call(:service_status, {:all})
  end

  def get(name) do
    GenServer.call(:service_status, {:get, name})
  end

  def update(name, is_live) do
    GenServer.call(:service_status, {:update, name, is_live})
  end

  # SERVER

  def init(_) do
    {:ok, Map.new()}
  end

  def handle_call({:all}, _from, state) do
    services = Enum.map  state,  fn {key, value} ->
      Map.merge(%{ name: key }, value)
    end
    {:reply, services, state}
  end

  def handle_call({:get, name}, _from, state) do
    {:reply, Map.get(state, name, :undefined), state}
  end

  def handle_call({:update, name, is_live}, _from, state) do
    case Map.get(state, name) do
      nil ->
        {:reply, :yes, Map.put(state, name, %{ is_live: is_live, last_checked: DateTime.utc_now() } )}

      _ ->
        {:reply, :yes, Map.put(state, name, %{ is_live: is_live, last_checked: DateTime.utc_now() } )}
    end
  end
end
