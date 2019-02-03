defmodule AlertTest do
  use ExUnit.Case
  alias Sitrep.Workers.Alert, as: Subject
  doctest Sitrep.Workers.Alert

  setup do
    Subject.start_link()

    service_config = %{
      "health_check_url" => "https://www.cultivatedcode.com",
      "name" => "marketing-site",
      "type" => "web",
      "test_interval_in_minutes" => 10
    }

    {:ok, service_config: service_config}
  end

  test "handle_cast/2 when first run", %{service_config: service_config} do
    {:noreply, result} = Subject.handle_cast({:send_alert, service_config, nil, true}, [])
    assert result == nil
  end

  test "handle_cast/2 when status has changed", %{service_config: service_config} do
    {:noreply, result} = Subject.handle_cast({:send_alert, service_config, false, true}, [])
    assert result == true
  end

  test "handle_cast/2 when status has not changed", %{service_config: service_config} do
    {:noreply, result} = Subject.handle_cast({:send_alert, service_config, false, false}, [])
    assert result == nil
  end
end
