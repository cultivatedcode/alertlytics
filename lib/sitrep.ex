defmodule Sitrep do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Sitrep.Workers.Config, ["test/fixtures/config.json"]),
      worker(Sitrep.Workers.Bootstrap, [])
    ]

    opts = [strategy: :one_for_one, name: Sitrep.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
