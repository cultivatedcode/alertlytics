defmodule Alertlytics.Workers.Alert do
  use GenServer

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
  def update_alert(service_config, previous_is_live, new_is_live) do
    GenServer.cast(__MODULE__, {:add_alert, service_config, previous_is_live, new_is_live})
  end

  # Server (Callbacks)

  def init(init_args) do
    schedule_work()
    {:ok, init_args}
  end

  def handle_info(:work, state) do
    alert(state)

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

  def handle_cast({:add_alert, service_config, previous_is_live, new_is_live}, state) do
    if previous_is_live != new_is_live && previous_is_live != nil do
      service_state = %{
        service_config: service_config,
        new_is_live: new_is_live,
        previous_is_live: previous_is_live
      }

      {:noreply, [service_state | state]}
    else
      {:noreply, state}
    end
  end

  def alert(state) do
    attachments =
      Enum.map(state, fn service_detail ->
        string_state =
          if service_detail[:new_is_live] do
            "fixed"
          else
            "failed"
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
end
