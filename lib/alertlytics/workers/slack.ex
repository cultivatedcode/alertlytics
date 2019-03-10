defmodule Alertlytics.Workers.Slack do
  use Slack
  require Logger

  @moduledoc """
  Documentation for Slack.
  Slack integration using the package library for interacting with Slack.
  """

  @doc """
    Initializes websocket connection to slack bot.
  """
  # Catch all message handler so we don't crash
  def handle_connect(slack, state) do
    Logger.info("Connected as #{slack.me.name}")
    {:ok, state}
  end

  @doc """
    Handler for any message received by the slack bot either in it's channel or when references `@chatops ping`.
  """
  def handle_event(message = %{type: "message"}, slack, state) do
    if Regex.run(~r/<@#{slack.me.id}>:?\sstatus/, message.text) do
      services = Alertlytics.Workers.Config.services()

      service_statuses =
        Enum.map(services, fn x ->
          Alertlytics.Workers.HttpHealthCheck.is_live(x["health_check_url"])
        end)

      live_count = Enum.count(service_statuses, fn x -> x end)
      all_services_count = Enum.count(service_statuses)

      color =
        if live_count == all_services_count do
          "#36a64f"
        else
          "#f90c0c"
        end

      attachment =
        Poison.encode!([
          %{
            color: color,
            title: "#{live_count} / #{all_services_count} healthy services",
            ts: DateTime.to_unix(DateTime.utc_now())
          }
        ])

      Slack.Web.Chat.post_message(message.channel, "Status Report", %{
        attachments: attachment
      })
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
