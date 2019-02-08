defmodule AlertTest do
  use ExUnit.Case
  alias Alertlytics.Workers.Alert, as: Subject
  doctest Alertlytics.Workers.Alert

  setup do
    Alertlytics.Workers.Config.start_link("test/fixtures/config.json")
    Subject.start_link()

    service_config = %{
      "health_check_url" => "https://www.cultivatedcode.com",
      "name" => "marketing-site",
      "type" => "web",
      "test_interval_in_minutes" => 5
    }

    {:ok, service_config: service_config}
  end

  test "handle_cast/2 when first run", %{service_config: service_config} do
    {:noreply, result} = Subject.handle_cast({:send_alert, service_config, nil, true}, [])
    assert result == nil
  end

  test "handle_cast/2 when status has changed from false to true", %{service_config: service_config} do
    {:noreply, result} = Subject.handle_cast({:send_alert, service_config, false, true}, [])
    assert result == true
  end

  test "handle_cast/2 when status has changed from true to false", %{service_config: service_config} do
    {:noreply, result} = Subject.handle_cast({:send_alert, service_config, true, false}, [])
    assert result == false
  end

  test "handle_cast/2 when status has not changed", %{service_config: service_config} do
    {:noreply, result} = Subject.handle_cast({:send_alert, service_config, false, false}, [])
    assert result == nil
  end
end
