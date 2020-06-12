defmodule Alertlytics.ServiceStatusTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = Alertlytics.ServiceStatus.start_link(:test_service_status)
    {:ok, registry: pid}
  end

  test "all services", %{registry: _pid} do
    Alertlytics.ServiceStatus.update("service", true)
    assert Enum.count(Alertlytics.ServiceStatus.all()) == 2
  end

  test "update a service", %{registry: _pid} do
    Alertlytics.ServiceStatus.update("service", true)
    assert Alertlytics.ServiceStatus.get("service")[:is_live] == true
  end

  test "get service for a service that does not exist", %{registry: _pid} do
    assert Alertlytics.ServiceStatus.get("wrong") == :undefined
  end

  test "get service", %{registry: _pid} do
    Alertlytics.ServiceStatus.update("service", true)
    assert Alertlytics.ServiceStatus.get("service")[:is_live] == true
  end
end
