defmodule Alertlytics.Workers.Alert do
  use GenServer
  require Logger

  @moduledoc """
  Documentation for Alert.
  Provides alerting services to send notifications to slack.
  """

  # Client

  @doc """
    Child spec for this module.
  """
  def child_spec(_) do
    Supervisor.Spec.worker(__MODULE__, [])
  end

  @doc """
    Starts the alert server.
  """
  def start_link(name \\ __MODULE__) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  @doc """
    Optionally queue an alert based on whether the previous_is_live is different from the new_is_live.
  """
  def update_alert(service_config, previous_is_live, new_is_live, duration) do
    GenServer.cast(
      __MODULE__,
      {:add_alert, service_config, previous_is_live, new_is_live, duration}
    )
  end

  # Server (Callbacks)

  def init(init_args) do
    schedule_work()
    {:ok, init_args}
  end

  def handle_info(:work, state) do
    slack_token = Application.get_env(:alertlytics, Alertlytics.Workers.Slack)[:token]

    if slack_token != "" do
      slack_alert(state)
    end

    {:ok, webhook_url} = Application.get_env(:alertlytics, :webhook)

    if webhook_url != "" do
      webhook_alert(state)
    end

    schedule_work()

    {:noreply, []}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  defp schedule_work do
    one_minute = 60_000
    Process.send_after(self(), :work, one_minute)
  end

  def handle_cast({:add_alert, service_config, previous_is_live, new_is_live, duration}, state) do
    if previous_is_live != new_is_live do
      service_state = %{
        service_config: service_config,
        new_is_live: new_is_live,
        previous_is_live: previous_is_live,
        duration: duration
      }

      {:noreply, [service_state | state]}
    else
      {:noreply, state}
    end
  end

  def slack_alert(state) do
    attachments =
      Enum.map(state, fn service_detail ->
        string_state =
          if service_detail[:previous_is_live] == nil do
            "live"
          else
            if service_detail[:new_is_live] do
              "fixed"
            else
              "failed"
            end
          end

        color =
          if service_detail[:new_is_live] do
            "#36a64f"
          else
            "#f90c0c"
          end

        title = "`#{service_detail[:service_config]["name"]}` health check #{string_state}"

        attachment = %{
          color: color,
          title: title,
          ns: DateTime.to_unix(DateTime.utc_now())
        }

        attachment
      end)

    if Enum.count(attachments) > 0 do
      channel = Alertlytics.Workers.Config.channel()

      Alertlytics.Services.SlackService.post_message(
        "Service Status Update",
        attachments,
        channel
      )
    end

    attachments
  end

  def webhook_alert(state) do
    Enum.each(state, fn service_detail ->
      string_state =
        if service_detail[:previous_is_live] == nil do
          "live"
        else
          if service_detail[:new_is_live] do
            "fixed"
          else
            "failed"
          end
        end

      Alertlytics.Services.WebhookService.post_message(
        service_detail[:service_config]["id"],
        service_detail[:service_config]["name"],
        string_state,
        service_detail[:duration]
      )
    end)
  end
end
