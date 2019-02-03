defmodule SitrepTest do
  use ExUnit.Case
  alias Sitrep, as: Subject
  doctest Sitrep

  setup do
    {:ok, app_pid} = Subject.start(nil, nil)
    {:ok, app: app_pid}
  end

  test "config service is available" do
    assert [
             %{
               "health_check_url" => "https://www.cultivatedcode.com",
               "name" => "marketing-site",
               "type" => "web",
               "test_interval_in_minutes" => 10
             },
             %{
               "health_check_url" => "http://web",
               "name" => "other",
               "test_interval_in_minutes" => 50,
               "type" => "web"
             }
           ] == Sitrep.Workers.Config.services()
  end
end
