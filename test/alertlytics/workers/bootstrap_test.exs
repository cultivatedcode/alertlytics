defmodule BootstrapTest do
  use ExUnit.Case
  alias Alertlytics.Workers.Bootstrap, as: Subject
  doctest Alertlytics.Workers.Bootstrap

  setup do
    Alertlytics.Workers.Config.start_link("test/fixtures/config.json", :test_config)
    Alertlytics.MonitorSupervisor.start_link(:test_monitor)
    {:ok, pid} = Subject.start_link(:test_bootstrap)
    {:ok, server: pid}
  end

  test "init" do
    {:ok, args} = Subject.init(nil)
    assert args == true
  end
end
