defmodule HelloWeb.StatusLive do
  use HelloWeb, :live_view
  require Logger

  alias Phoenix.LiveView.Socket

  # def render(assigns) do
  #   ~L"""
  #   <h2>Show User</h2>
  #   <%= @data %>
  #   """
  # end

  def mount(_params, _session, socket) do
    # if connected?(socket), do:
    Alertlytics.ServiceStatus.subscribe()
    {:ok, fetch(socket)}
  end

  def handle_info({Alertlytics.ServiceStatus, _}, socket) do
    Logger.info("UPDATING UI")
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, data: Alertlytics.ServiceStatus.all)
  end
end
