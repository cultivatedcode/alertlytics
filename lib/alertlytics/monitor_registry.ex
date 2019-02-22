defmodule Alertlytics.MonitorRegistry do
  use GenServer

  # API

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :registry)
  end

  def whereis_name(monitor_name) do
    GenServer.call(:registry, {:whereis_name, monitor_name})
  end

  def register_name(monitor_name, pid) do
    GenServer.call(:registry, {:register_name, monitor_name, pid})
  end

  def unregister_name(monitor_name) do
    GenServer.cast(:registry, {:unregister_name, monitor_name})
  end

  def send(monitor_name, message) do
    case whereis_name(monitor_name) do
      :undefined ->
        {:badarg, {monitor_name, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  # SERVER

  def init(_) do
    {:ok, Map.new()}
  end

  def handle_call({:whereis_name, monitor_name}, _from, state) do
    {:reply, Map.get(state, monitor_name, :undefined), state}
  end

  def handle_call({:register_name, monitor_name, pid}, _from, state) do
    case Map.get(state, monitor_name) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(state, monitor_name, pid)}

      _ ->
        {:reply, :no, state}
    end
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    {:noreply, remove_pid(state, pid)}
  end

  def remove_pid(state, pid_to_remove) do
    remove = fn {_key, pid} -> pid != pid_to_remove end
    Enum.filter(state, remove) |> Enum.into(%{})
  end

  def handle_cast({:unregister_name, monitor_name}, state) do
    {:noreply, Map.delete(state, monitor_name)}
  end
end
