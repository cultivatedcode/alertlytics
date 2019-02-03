defmodule ConfigTest do
  use ExUnit.Case
  alias Sitrep.Workers.Config, as: Subject
  doctest Sitrep.Workers.Config

  setup do
    {:ok, server_pid} = Subject.start_link("test/fixtures/config.json")
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
           ] == Subject.services()
  end

  test "config file missing" do
    assert_raise RuntimeError,
                 "Error test/fixtures/does-not-exist.json not found in /home/app",
                 fn ->
                   Subject.start_link("test/fixtures/does-not-exist.json")
                 end
  end
end
