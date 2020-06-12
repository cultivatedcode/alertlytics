defmodule AlertlyticsWeb.StatusLive do
  use AlertlyticsWeb, :live_view
  alias Phoenix.LiveView.Socket
  require Logger

  @moduledoc """
  Documentation for StatusLive.
  The LiveView controller for the dashboard which reports all service status changes anytime
  a service status changes.
  """

  def mount(_params, _session, socket) do
    # if connected?(socket), do: :timer.send_interval(1000, self(), :tick)
    Alertlytics.ServiceStatus.subscribe()
    {:ok, fetch(socket)}
  end

  def handle_info({Alertlytics.ServiceStatus, _}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Updated")
     |> fetch()}
  end

  defp fetch(socket) do
    assign(socket, data: Alertlytics.ServiceStatus.all())
  end
end
