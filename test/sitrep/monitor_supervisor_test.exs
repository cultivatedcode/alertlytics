defmodule MonitorSupervisorTest do
  use ExUnit.Case

  test "should create http monitor" do
    {:ok, _} = Sitrep.MonitorSupervisor.start_link()
    {:ok, pid} = Sitrep.MonitorSupervisor.add_monitor(%{
        "health_check_url" => "https://www.cultivatedcode.com",
        "name" => "marketing-site",
        "type" => "web",
        "test_interval_in_minutes" => 10
      }) 
    
    assert pid != nil
  end 
end