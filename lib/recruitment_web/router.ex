defmodule RecruitmentWeb.Router do
  use RecruitmentWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RecruitmentWeb.Plug.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RecruitmentWeb do
    pipe_through :browser # Use the default browser stack

    get "/recruit/", PageController, :index
    post "/recruit/", PageController, :login_signup
    get "/recruit/positions", PageController, :positions
    post "/recruit/positions", PageController, :positions_post
    post "/recruit/registration", PageController, :registration
    get "/recruit/done", PageController, :positions # change to done
    post "/recruit/logout", PageController, :logout
    get "/recruit/logout", PageController, :logout
    get "/*path", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RecruitmentWeb do
  #   pipe_through :api
  # end
end
