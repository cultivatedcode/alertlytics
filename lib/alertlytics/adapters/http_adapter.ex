defmodule Alertlytics.Adapters.HttpAdapter do
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
    HTTPoison.start()
    url = config["health_check_url"]

    is_live_now =
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200}} ->
          Logger.info(" - '#{url}' is live")
          true

        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.info(inspect(reason))
          false

        _ ->
          Logger.info(" - '#{url}' is down")
          false
      end

    is_live_now
  end
end
