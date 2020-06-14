defmodule RabbitMqServiceTest do
  use ExUnit.Case
  alias Alertlytics.Services.RabbitMqService, as: Subject
  doctest Alertlytics.Services.RabbitMqService

  test "parse_response" do
    assert 1 == Subject.consumer_count_from_response("{ \"consumers\": 1 }")
  end

  test "bad address" do
    assert false == Subject.check("http://guest:guest@wrong:15672", "/", "test.queue")
  end
end
