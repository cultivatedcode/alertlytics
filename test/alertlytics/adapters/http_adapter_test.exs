defmodule HttpAdapterTest do
  use ExUnit.Case
  alias Alertlytics.Adapters.HttpAdapter, as: Subject
  doctest Alertlytics.Adapters.HttpAdapter

  test "good url" do
    assert true ==
             Subject.check(%{
               "health_check_url" => "https://www.cultivatedcode.com"
             })
  end

  test "bad url" do
    assert false ==
             Subject.check(%{
               "health_check_url" => "https://incorrect.cultivatedcode.com"
             })
  end
end
