defmodule Sitrep.Workers.Alert do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def optionally_send_alert(service_config, previous_is_live, new_is_live) do
    GenServer.cast(__MODULE__, {:send_alert, service_config, previous_is_live, new_is_live})
  end

  def init(init_args) do
    {:ok, init_args}
  end

  def handle_cast({:send_alert, service_config, previous_is_live, new_is_live}, _state) do
    message_sent = if previous_is_live != new_is_live && previous_is_live != nil do
      IO.puts("ALERTING")
      # Slack.Web.Chat.post_message("#commits", "testing123")
      true
    end

    {:noreply, message_sent}
  end
end
