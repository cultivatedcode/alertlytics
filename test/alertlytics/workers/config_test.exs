defmodule ConfigTest do
  use ExUnit.Case
  alias Alertlytics.Workers.Config, as: Subject
  doctest Alertlytics.Workers.Config

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
               "test_interval_in_minutes" => 5
             }
           ] == Subject.services()
  end

  test "channel" do
    assert "#alerts" == Subject.channel()
  end

  test "config file missing" do
    assert_raise RuntimeError, fn ->
      Subject.start_link("test/fixtures/does-not-exist.json")
    end
  end
end
