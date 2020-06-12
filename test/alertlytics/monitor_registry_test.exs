defmodule Alertlytics.MonitorRegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = Alertlytics.MonitorRegistry.start_link(:test_registry)
    {:ok, registry: pid}
  end

  test "checks if a named process is included", %{registry: pid} do
    assert Alertlytics.MonitorRegistry.whereis_name("wrong") == :undefined

    Alertlytics.MonitorRegistry.register_name("self", pid)
    assert Alertlytics.MonitorRegistry.whereis_name("self") == pid
  end

  test "unregister a process", %{registry: pid} do
    Alertlytics.MonitorRegistry.register_name("self", pid)
    assert Alertlytics.MonitorRegistry.whereis_name("self") == pid
    Alertlytics.MonitorRegistry.unregister_name("self")
    assert Alertlytics.MonitorRegistry.whereis_name("self") == :undefined
  end

  test "send message", %{registry: pid} do
    Alertlytics.MonitorRegistry.register_name("self", pid)
    assert Alertlytics.MonitorRegistry.send("self", {:whereis, "self"}) == pid
  end
end
