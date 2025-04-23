defmodule OcularWeb.Router do
  use OcularWeb, :router

  import OcularWeb.PlayerAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_player
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OcularWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", OcularWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ocular, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: OcularWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", OcularWeb do
    pipe_through [:browser, :redirect_if_player_is_authenticated]

    get "/players/register", PlayerRegistrationController, :new
    post "/players/register", PlayerRegistrationController, :create
    get "/players/log_in", PlayerSessionController, :new
    post "/players/log_in", PlayerSessionController, :create
    get "/players/reset_password", PlayerResetPasswordController, :new
    post "/players/reset_password", PlayerResetPasswordController, :create
    get "/players/reset_password/:token", PlayerResetPasswordController, :edit
    put "/players/reset_password/:token", PlayerResetPasswordController, :update
  end

  scope "/", OcularWeb do
    pipe_through [:browser, :require_authenticated_player]

    get "/players/settings", PlayerSettingsController, :edit
    put "/players/settings", PlayerSettingsController, :update
    get "/players/settings/confirm_email/:token", PlayerSettingsController, :confirm_email

    get "/events", EventRegistrationController, :index
    get "/events/:event_id", EventRegistrationController, :show

    get "/builds/:build_id", EventRegistrationController, :update_build
    get "/builds/:build_id/leave_build", EventRegistrationController, :leave_build
    post "/events/:event_id/edit", EventRegistrationController, :update
  end

  scope "/", OcularWeb do
    pipe_through [:browser, :require_authenticated_player, :require_admin_player]

    get "/players", PlayerRegistrationController, :index
    get "/players/:player_id/authorize/:authorize", PlayerRegistrationController, :authorize

    get "/events/:event_id/edit", EventRegistrationController, :edit

    get "/events/register/new", EventRegistrationController, :new
    post "/events/register/new", EventRegistrationController, :create
  end

  scope "/", OcularWeb do
    pipe_through [:browser]

    # get "/players/register", PlayerRegistrationController, :new

    get "/players/log_out", PlayerSessionController, :delete
    get "/players/confirm", PlayerConfirmationController, :new
    post "/players/confirm", PlayerConfirmationController, :create
    get "/players/confirm/:token", PlayerConfirmationController, :edit
    post "/players/confirm/:token", PlayerConfirmationController, :update
  end
end
