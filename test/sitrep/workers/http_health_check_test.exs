defmodule HttpHealthCheckTest do
  use ExUnit.Case, async: true
  doctest Sitrep.Workers.HttpHealthCheck

  # test "test http end point without timer" do
  #   {:ok, pid} = Sitrep.Workers.HttpHealthCheck.start_link([], %{
  #              "health_check_url" => "https://www.cultivatedcode.com",
  #              "name" => "marketing-site",
  #              "type" => "web",
  #              "test_interval_in_minutes" => 1
  #            }
  #         )
  #   assert :work == send(pid, :work)
  # end

  # test "test http end point with timer" do
  #   {:ok, pid} = Sitrep.Workers.HttpHealthCheck.start_link([], %{
  #              "health_check_url" => "https://www.cultivatedcode.com",
  #              "name" => "marketing-site",
  #              "type" => "web",
  #              "test_interval_in_minutes" => 10
  #            }
  #         )
  #   assert :work == send(pid, :work)
  # end

  test "start_link" do
    {:ok, pid} =
      Sitrep.Workers.HttpHealthCheck.start_link([], %{
        "health_check_url" => "https://www.cultivatedcode.com",
        "name" => "marketing-site",
        "type" => "web",
        "test_interval_in_minutes" => 10
      })

    assert pid != nil
  end

  test "handle_call/2" do
    state = %{
      service_config: %{
        "health_check_url" => "https://www.cultivatedcode.com",
        "name" => "marketing-site",
        "type" => "web",
        "test_interval_in_minutes" => 10
      },
      delay: 1,
      is_live: nil
    }

    {:noreply, newstate} = Sitrep.Workers.HttpHealthCheck.handle_info(:work, state)
    assert newstate[:is_live] == true
  end

  test "handle_call/2 with alert" do
    state = %{
      service_config: %{
        "health_check_url" => "https://www.cultivatedcode.com",
        "name" => "marketing-site",
        "type" => "web",
        "test_interval_in_minutes" => 10
      },
      delay: 1,
      is_live: false
    }

    {:noreply, newstate} = Sitrep.Workers.HttpHealthCheck.handle_info(:work, state)
    assert newstate[:is_live] == true
  end
end
