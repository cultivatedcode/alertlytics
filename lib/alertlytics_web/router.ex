defmodule AlertlyticsWeb.Router do
  use AlertlyticsWeb, :router

  @moduledoc """
  Documentation for Router.
  """

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {AlertlyticsWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", AlertlyticsWeb do
    pipe_through(:browser)

    live("/", StatusLive, :index)
  end
end
