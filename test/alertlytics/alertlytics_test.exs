defmodule AlertlyticsTest do
  use ExUnit.Case
  alias Alertlytics, as: Subject
  doctest Alertlytics

  import Mock

  @tag :skip
  test "config service is available" do
    with_mock Slack.Bot,
      start_link: fn _slack, _state, _token -> {:ok, self()} end do
      {:ok, _pid} = Subject.start(nil, nil)

      assert [
               %{
                 "health_check_url" => "https://www.cultivatedcode.com",
                 "name" => "marketing-site",
                 "type" => "web",
                 "test_interval_in_seconds" => 60
               },
               %{
                 "health_check_url" => "http://web",
                 "name" => "other",
                 "test_interval_in_seconds" => 10,
                 "type" => "web"
               }
             ] == Alertlytics.Workers.Config.services()
    end
  end
end
