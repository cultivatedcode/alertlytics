defmodule RabbitMqAdapterTest do
  use ExUnit.Case
  alias Alertlytics.Adapters.RabbitMqAdapter, as: Subject
  doctest Alertlytics.Adapters.RabbitMqAdapter

  test "parse_response" do
    assert 1 == Subject.consumer_count_from_response("{ \"consumers\": 1 }")
  end

  test "bad address" do
    assert false ==
             Subject.check(%{
               "rabbit_admin_url" => "http://guest:guest@wrong:15672",
               "rabbit_vhost" => "/",
               "rabbit_queue_name" => "test.queue"
             })
  end
end
