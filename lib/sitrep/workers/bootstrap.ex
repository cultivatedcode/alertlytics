defmodule Sitrep.Workers.Bootstrap do
  use GenServer
  @moduledoc """
  Documentation for Bootstrap.
  Bootstrap process which starts all of the monitoring.
  """

  # Client

  @doc """
    Starts the config server.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Server (Callbacks)

  def init(init_arg) do 
    services = Sitrep.Workers.Config.services
    IO.puts "Initializing monitoring."
    IO.puts "------------------------"
    Enum.each services, fn service -> 
      IO.inspect service
    end
    {:ok, init_arg}
  end
end