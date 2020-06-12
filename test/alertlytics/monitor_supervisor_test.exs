defmodule MonitorSupervisorTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Alertlytics.MonitorRegistry.start_link(:test_registry_for_supervisor)
    {:ok, registry: pid}
  end

  test "should create http monitor" do
    {:ok, _} = Alertlytics.MonitorSupervisor.start_link(:test_supervisor)

    {:ok, pid} =
      Alertlytics.MonitorSupervisor.add_monitor(%{
        "health_check_url" => "https://www.cultivatedcode.com",
        "name" => "marketing-site-test",
        "type" => "web",
        "test_interval_in_minutes" => 5
      })

    assert pid != nil
  end
end
