defmodule ConfigTest do
  use ExUnit.Case
  doctest Sitrep.Workers.Config

  setup do
    {:ok, server_pid} = Sitrep.Workers.Config.start_link("test/fixtures/config.json")
    {:ok, server: server_pid}
  end

  test "list services" do
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
