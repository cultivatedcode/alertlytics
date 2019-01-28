defmodule SitrepTest do
  use ExUnit.Case
  doctest Sitrep

  setup do
    {:ok,app_pid} = Sitrep.start(nil,nil)
    {:ok, app: app_pid}
  end

  test "workers available" do
    assert [
              %{
                "health_check_url" => "https://www.cultivatedcode.com",
                "name" => "production",
                "type" => "web"
              }
            ] == Sitrep.Workers.Config.services
  end
end