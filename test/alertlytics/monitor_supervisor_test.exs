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
        "name" => "marketing-site-test",
        "type" => "http",
        "test_interval_in_seconds" => 60,
        "config" => %{
          "health_check_url" => "https://www.cultivatedcode.com"
        }
      })

    assert pid != nil
  end
end
