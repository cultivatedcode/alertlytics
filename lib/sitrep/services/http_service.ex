defmodule Sitrep.Services.HttpService do
  @moduledoc """
  Documentation for HttpService.
  Checks if the given url returns status 200.
  """

  # Client

  @doc """
  Returns true if the url returns a status of 200.
  """
  def check(url) do
    IO.puts("Checking status for '#{url}'")
    HTTPoison.start()

    is_live_now =
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200}} ->
          IO.puts("SUCCESS!!!")
          true

        _ ->
          false
      end

    is_live_now
  end
end
