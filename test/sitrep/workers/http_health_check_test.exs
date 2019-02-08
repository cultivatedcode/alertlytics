defmodule HttpHealthCheckTest do
  use ExUnit.Case, async: true
  alias Sitrep.Workers.HttpHealthCheck, as: Subject
  doctest Sitrep.Workers.HttpHealthCheck

  test "start_link" do
    {:ok, pid} =
      Subject.start_link([], %{
        "health_check_url" => "https://www.cultivatedcode.com",
        "name" => "marketing-site",
        "type" => "web",
        "test_interval_in_minutes" => 5
      })

    assert pid != nil
  end

  test "handle_call/2" do
    state = %{
      service_config: %{
        "health_check_url" => "https://www.cultivatedcode.com",
        "name" => "marketing-site",
        "type" => "web",
        "test_interval_in_minutes" => 5
      },
      delay: 1,
      is_live: nil
    }

    {:noreply, newstate} = Subject.handle_info(:work, state)
    assert newstate[:is_live] == true
  end
end
