defmodule Alertlytics.Adapters.RabbitMqAdapter do
  require Logger

  @moduledoc """
  Documentation for HttpService.
  Checks if the given url returns status 200.
  """

  # Client

  @doc """
  Returns true if the url returns a status of 200.
  """
  def check(config) do
    url = config["rabbit_admin_url"]
    vhost = config["rabbit_vhost"]
    queue_name = config["rabbit_queue_name"]
    HTTPoison.start()

    is_live_now =
      case HTTPoison.get("#{url}/api/queues/#{URI.encode_www_form(vhost)}/#{queue_name}") do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          consumers = consumer_count_from_response(body)
          Logger.info(" - '#{queue_name}' has #{consumers} consumers")
          consumers > 0

        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.info(inspect(reason))
          false

        response ->
          Logger.info(" - '#{queue_name}' has no consumers")
          Logger.debug(inspect(response))
          false
      end

    is_live_now
  end

  def consumer_count_from_response(body) do
    response = Poison.decode!(body)
    response["consumers"]
  end
end
