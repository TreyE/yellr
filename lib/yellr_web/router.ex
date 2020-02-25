defmodule YellrWeb.Router do
  use YellrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :check_login do
    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"},
      module: Yellr.Authentication.Guardian,
      error_handler: YellrWeb.SessionsController
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"},
      module: Yellr.Authentication.Guardian,
      error_handler: YellrWeb.SessionsController
    plug Guardian.Plug.EnsureAuthenticated,
      module: Yellr.Authentication.Guardian,
      error_handler: YellrWeb.SessionsController
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug YellrWeb.ApiKeyPlug
  end

  scope "/api", YellrWeb.Api do
    pipe_through :api

    resources "/build_results", BuildResultsController, only: [:create]
  end

  scope "/", YellrWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sessions", SessionsController, only: [:new, :create]
  end

  scope "/", YellrWeb do
    pipe_through([:browser, :check_login])

    delete "/sessions", SessionsController, :destroy

    resources "/branches", BranchesController, only: [:new, :create, :delete, :update]
    resources "/projects", ProjectsController, except: [:delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", YellrWeb do
  #   pipe_through :api
  # end
end
