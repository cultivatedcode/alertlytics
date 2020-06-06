defmodule HelloWeb.PageController do
  use HelloWeb, :controller
  alias HelloWeb.Router.Helpers, as: Routes
  require Logger

  def index(conn, _params) do
    services = Alertlytics.ServiceStatus.all()

    conn
    |> Plug.Conn.assign(:status, "Operational")
    |> Plug.Conn.assign(:services, services)
    |> render("index.html")
  end

  def refresh(conn, _) do
    Logger.info("REFRESH")
    conn
    |> put_flash(:info, "Refresh triggered!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
