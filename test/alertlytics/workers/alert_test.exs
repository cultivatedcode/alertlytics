defmodule AlertTest do
  use ExUnit.Case
  alias Alertlytics.Workers.Alert, as: Subject
  doctest Alertlytics.Workers.Alert

  import Mock

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

  test "handle_info/2" do
    {:ok, state} = Subject.handle_info(nil, %{test: true})
    assert %{test: true} == state
  end

  test "alert/1 when alert should occur on fixed" do
    with_mock Alertlytics.Services.SlackService,
      post_message: fn _title, _attachments, _channel -> nil end do
      alerts = Subject.alert([%{service_config: %{name: "test"}, new_is_live: true}])
      assert 1 == Enum.count(alerts)
      assert ["#36a64f"] == Enum.map(alerts, fn alert -> alert[:color] end)
    end
  end

  test "alert/1 when alert should occur on failed" do
    with_mock Alertlytics.Services.SlackService,
      post_message: fn _title, _attachments, _channel -> nil end do
      alerts = Subject.alert([%{service_config: %{name: "test"}, new_is_live: false}])
      assert 1 == Enum.count(alerts)
      assert ["#f90c0c"] == Enum.map(alerts, fn alert -> alert[:color] end)
    end
  end

  test "alert/1 when alert should not occur" do
    with_mock Alertlytics.Services.SlackService,
      post_message: fn _title, _attachments, _channel -> nil end do
      alerts = Subject.alert([])
      assert Enum.empty?(alerts)
    end
  end

  test "handle_cast/2 when first run", %{service_config: service_config} do
    {:noreply, result} = Subject.handle_cast({:add_alert, service_config, nil, true}, [])
    assert result == []
  end

  test "handle_cast/2 when status has changed from false to true", %{
    service_config: service_config
  } do
    {:noreply, result} = Subject.handle_cast({:add_alert, service_config, false, true}, [])
    assert 1 == Enum.count(result)
  end

  test "handle_cast/2 when status has changed from true to false", %{
    service_config: service_config
  } do
    {:noreply, result} = Subject.handle_cast({:add_alert, service_config, true, false}, [])
    assert 1 == Enum.count(result)
  end

  test "handle_cast/2 when status has not changed", %{service_config: service_config} do
    {:noreply, result} = Subject.handle_cast({:add_alert, service_config, false, false}, [])
    assert result == []
  end
end
