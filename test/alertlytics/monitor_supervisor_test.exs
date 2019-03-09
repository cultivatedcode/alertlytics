defmodule MonitorSupervisorTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Alertlytics.MonitorRegistry.start_link()
    {:ok, registry: pid}
  end

  test "should create http monitor" do
    {:ok, _} = Alertlytics.MonitorSupervisor.start_link()

    {:ok, pid} =
      Alertlytics.MonitorSupervisor.add_monitor(%{
        "health_check_url" => "https://www.cultivatedcode.com",
        "name" => "marketing-site",
        "type" => "web",
        "test_interval_in_minutes" => 5
      })

    assert pid != nil
  end
end
