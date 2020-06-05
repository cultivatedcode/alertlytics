defmodule HelloWeb.PageController do
  use HelloWeb, :controller
  require Logger

  def index(conn, _params) do
    services = Alertlytics.ServiceStatus.all()

    conn
    |> Plug.Conn.assign(:status, "Operational")
    |> Plug.Conn.assign(:services, services)
    |> render("index.html")
  end
end
