defmodule HelloWeb.PageController do
  use HelloWeb, :controller
  require Logger

  def index(conn, _params) do
    services = Alertlytics.Workers.Config.services()
    Logger.info("-Init #{Enum.count(services)}")

    conn
    |> Plug.Conn.assign(:status, "Operational")
    |> Plug.Conn.assign(:services, services)
    |> render("index.html")
  end
end
