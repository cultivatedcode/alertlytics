defmodule ConfigTest do
  use ExUnit.Case
  alias Alertlytics.Workers.Config, as: Subject
  doctest Alertlytics.Workers.Config

  setup do
    {:ok, server_pid} = Subject.start_link("test/fixtures/config.json", :test_config)
    {:ok, server: server_pid}
  end

  test "list services" do
    assert [
             %{
              "config" => %{
                "health_check_url" => "http://www.cultivatedcode.com"
              },
              "name" => "marketing-site",
              "type" => "http",
              "test_interval_in_seconds" => 60
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
