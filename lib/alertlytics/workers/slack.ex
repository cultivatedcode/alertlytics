defmodule Alertlytics.Workers.Slack do
  use Slack

  # Catch all message handler so we don't crash
  def handle_connect(slack, state) do
    IO.puts("Connected as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    if Regex.run(~r/<@#{slack.me.id}>:?\sping/, message.text) do
      send_message("<@#{message.user}> pong", message.channel, slack)
    else
      send_message("Hello world", message.channel, slack)
    end

    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    send_message(text, channel, slack)
    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}
end
