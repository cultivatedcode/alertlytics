defmodule Sitrep do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Sitrep.Workers.Config, ["/etc/sitrep/config.json"]),
      worker(Sitrep.Workers.Alert, []),
      worker(Sitrep.MonitorSupervisor, []),
      worker(Sitrep.Workers.Bootstrap, [])
    ]

    opts = [strategy: :one_for_one, name: Sitrep.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
