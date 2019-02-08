defmodule BootstrapTest do
  use ExUnit.Case
  alias Sitrep.Workers.Bootstrap, as: Subject
  doctest Sitrep.Workers.Bootstrap

  setup do
    Sitrep.Workers.Config.start_link("test/fixtures/config.json")
    Sitrep.MonitorSupervisor.start_link()
    {:ok, pid} = Subject.start_link()
    {:ok, server: pid}
  end

  test "init" do
    {:ok, args} = Subject.init(nil)
    assert args == true
  end
end
