defmodule HttpServiceTest do
  use ExUnit.Case
  doctest Sitrep.Services.HttpService

  test "good url" do
    assert true == Sitrep.Services.HttpService.check("https://www.cultivatedcode.com")
  end

  test 'bad url' do
    assert false == Sitrep.Services.HttpService.check("http://www.cultivatedcode.com")
  end
end
