defmodule HttpServiceTest do
  use ExUnit.Case
  alias Sitrep.Services.HttpService, as: Subject
  doctest Sitrep.Services.HttpService

  test "good url" do
    assert true == Subject.check("https://www.cultivatedcode.com")
  end

  test "bad url" do
    assert false == Subject.check("http://www.cultivatedcode.com")
  end
end
