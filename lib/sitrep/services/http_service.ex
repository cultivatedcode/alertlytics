defmodule Sitrep.Services.HttpService do
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
