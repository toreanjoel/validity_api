defmodule ValidityServerWeb.Router do
  alias ValidityServerWeb.ApiController
  use ValidityServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ValidityServerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Plugs.Auth
  end

  # AUTH -- START
  scope "/oauth", ValidityServerWeb do
    pipe_through [:browser]

    get "/authorize", OAuthController, :authorize
    get "/callback", OAuthController, :callback
  end

  # AUTH -- STOP

  # API -- START
  scope "/api" do
    pipe_through [:api, :auth]

    # API routes
    get "/", ApiController, :index
    post "/validate", ApiController, :validate
  end
  # API -- END

  # Browser -- START
  scope "/", ValidityServerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
  # Broweser -- END

  # ----------------------------------------------------------------
  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ValidityServerWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
  # ----------------------------------------------------------------
end
