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

  scope "/recruit_api", RecruitmentWeb do
    pipe_through :api

    get "/get_all_related_tables", ApiController, :get_all_related_tables
    get "/get_positions", ApiController, :get_positions
    get "/get_qualifications", ApiController, :get_qualifications
    get "/get_applicant_details", ApiController, :get_applicant_details
    get "/get_applicants_other_details", ApiController, :get_applicants_other_details
    get "/delete_result", ApiController, :delete_result
  end

  scope "/", RecruitmentWeb do
    pipe_through :browser # Use the default browser stack

    get "/recruit/", PageController, :index
    post "/recruit/", PageController, :login_signup
    get "/recruit/positions", PageController, :positions
    post "/recruit/positions", PageController, :positions_post
    get "/recruit/registration", PageController, :registration
    post "/recruit/registration", PageController, :registration_post
    get "/recruit/qualifications", PageController, :qualifications
    post "/recruit/qualifications", PageController, :qualifications_post
    get "/recruit/experience", PageController, :experience
    post "/recruit/experience", PageController, :experience_post
    get "/recruit/attachments", PageController, :attachments
    post "/recruit/attachments", PageController, :attachments_post
    get "/recruit/done", PageController, :done
    get "/recruit/info", PageController, :info
    get "/recruit/print_ref", PageController, :print_ref
    get "/recruit/print_referee", PageController, :print_referee
    post "/recruit/logout", PageController, :logout
    get "/recruit/logout", PageController, :logout
    get "/prison_cms_files/:file", PageController, :get_file
    get "/*path", PageController, :index
  end

  # Other scopes may use custom stacks.
end
