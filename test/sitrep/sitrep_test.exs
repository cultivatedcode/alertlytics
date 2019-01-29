defmodule SitrepTest do
  use ExUnit.Case
  doctest Sitrep

  setup do
    {:ok, app_pid} = Sitrep.start(nil, nil)
    {:ok, app: app_pid}
  end

  test "config service is available" do
    assert [
             %{
               "health_check_url" => "https://www.cultivatedcode.com",
               "name" => "marketing-site",
               "type" => "web",
               "test_interval_in_minutes" => 10
             }
           ] == Sitrep.Workers.Config.services()
  end
end
