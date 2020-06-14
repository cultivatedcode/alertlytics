defmodule HealthMonitorTest do
  use ExUnit.Case
  alias Alertlytics.Workers.HealthMonitor, as: Subject
  doctest Alertlytics.Workers.HealthMonitor

  setup do
    {:ok, pid} = Alertlytics.MonitorRegistry.start_link(:test_registry_for_health_monitor)
    {:ok, registry: pid}
  end

  test "start_link" do
    {:ok, pid} = Subject.start_link([], service_config())

    assert pid != nil
  end

  test "handle_call/2" do
    state = %{
      service_config: service_config(),
      delay: 1,
      is_live: nil
    }

    {:noreply, newstate} = Subject.handle_info(:work, state)
    assert newstate[:is_live] == true
  end

  test "handle_call/3" do
    state = %{
      service_config: service_config(),
      delay: 1,
      is_live: true
    }

    {:reply, is_live, _new_state} = Subject.handle_call(:is_live, nil, state)
    assert is_live == true
  end

  defp service_config do
    %{
      "config" => %{
        "health_check_url" => "https://www.google.com"
      },
      "name" => "marketing-site",
      "type" => "http",
      "test_interval_in_seconds" => 60
    }
  end
end
