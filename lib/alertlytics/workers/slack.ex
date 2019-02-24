defmodule Alertlytics.Workers.Slack do
  use Slack

  @moduledoc """
  Documentation for Slack.
  Slack integration using the package library for interacting with Slack.
  """

  @doc """
    Initializes websocket connection to slack bot.
  """
  # Catch all message handler so we don't crash
  def handle_connect(slack, state) do
    IO.puts("Connected as #{slack.me.name}")
    {:ok, state}
  end

  @doc """
    Handler for any message received by the slack bot either in it's channel or when references `@chatops ping`.
  """
  def handle_event(message = %{type: "message"}, slack, state) do
    if Regex.run(~r/<@#{slack.me.id}>:?\sping/, message.text) do
      send_message("<@#{message.user}> pong", message.channel, slack)
    end

    {:ok, state}
  end

  @doc """
    Catch all matcher for all other event types
  """
  def handle_event(_, _, state), do: {:ok, state}

  @doc """
    Sends programmatic slack messages to the provided channel
  """
  def handle_info({:message, text, channel}, slack, state) do
    send_message(text, channel, slack)
    {:ok, state}
  end

  @doc """
    Catch all matcher for all other info types
  """
  def handle_info(_, _, state), do: {:ok, state}
end
