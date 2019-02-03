defmodule Sitrep.Workers.Alert do
  use GenServer

  @moduledoc """
  Documentation for Alert.
  Provides alerting services to send notifications to slack.
  """

  # Client

  @doc """
    Starts the alert server.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
    Optionally send an alert based on whether the previous_is_live is different from the new_is_live.
  """
  def optionally_send_alert(service_config, previous_is_live, new_is_live) do
    GenServer.cast(__MODULE__, {:send_alert, service_config, previous_is_live, new_is_live})
  end

  # Server (Callbacks)

  def init(init_args) do
    {:ok, init_args}
  end

  def handle_cast({:send_alert, _service_config, previous_is_live, new_is_live}, _state) do
    message_sent =
      if previous_is_live != new_is_live && previous_is_live != nil do
        IO.puts("ALERTING")
        # Slack.Web.Chat.post_message("#commits", "testing123")
        true
      end

    {:noreply, message_sent}
  end
end
