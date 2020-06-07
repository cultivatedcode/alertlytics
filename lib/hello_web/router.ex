defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug :put_root_layout, {HelloWeb.LayoutView, :root}
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", HelloWeb do
    pipe_through(:browser)

    live "/", StatusLive, :index
  end
end
