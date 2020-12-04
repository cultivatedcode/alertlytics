defmodule Alertlytics.Services.WebhookService do
  require Logger

  @moduledoc """
  Documentation for WebhookService.
  Handles slack interactions.
  """

  @doc """
  Posts a message to the webhook.
  """
  def post_message(name, state, duration_in_ms) do
    {:ok, webhook_url} = Application.get_env(:alertlytics, :webhook)

    if webhook_url != nil do
      Logger.info("SENDING #{webhook_url}")

      payload = %{
        state: state,
        name: name,
        duration_in_ms: duration_in_ms,
        ns: DateTime.to_unix(DateTime.utc_now())
      }

      headers = [{"Content-type", "application/json"}]

      {status, res} =
        HTTPoison.post(
          webhook_url,
          Poison.encode!(payload),
          headers
        )
    end
  end
end
