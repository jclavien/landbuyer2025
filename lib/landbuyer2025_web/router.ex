defmodule Landbuyer2025Web.Router do
  use Landbuyer2025Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {Landbuyer2025Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Landbuyer2025Web do
    pipe_through :browser

    live "/", Live.DashboardLive, :index

  end

  # Other scopes may use custom stacks.
  # scope "/api", Landbuyer2025Web do
  #   pipe_through :api
  # end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:landbuyer2025, :dev_routes) do

    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
