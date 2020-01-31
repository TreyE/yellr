defmodule YellrWeb.Router do
  use YellrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug YellrWeb.ApiKeyPlug
  end

  scope "/", YellrWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", YellrWeb do
    pipe_through :browser

    resources "/branches", BranchesController, only: [:new, :create, :delete, :update]
    resources "/projects", ProjectsController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", YellrWeb do
  #   pipe_through :api
  # end
end
