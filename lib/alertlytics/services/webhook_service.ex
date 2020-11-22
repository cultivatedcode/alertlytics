defmodule Alertlytics.Services.WebhookService do
  require Logger

  @moduledoc """
  Documentation for WebhookService.
  Handles slack interactions.
  """

  @doc """
  Posts a message to the webhook.
  """
  def post_message(name, state) do
    webhook_url = Application.get_env(:alertlytics, :webhook)

    if webhook_url != nil do
      Logger.info("SENDING")

      payload = %{
        state: state,
        name: name,
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
