defmodule Alertlytics.Services.SlackService do
  @moduledoc """
  Documentation for SlackService.
  Handles slack interactions.
  """

  def post_message(text, attachments, channel) do
    if Enum.count(attachments) > 0 do
      attachments_json = Poison.encode!(attachments)

      Slack.Web.Chat.post_message(channel, text, %{
        attachments: attachments_json
      })
    end
  end
end
