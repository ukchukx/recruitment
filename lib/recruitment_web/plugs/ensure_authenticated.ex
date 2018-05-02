defmodule RecruitmentWeb.Plug.EnsureAuthenticated do
  alias Recruitment.Recruit
  import Plug.Conn, only: [halt: 1]

  def init(opts), do: opts

  def call(%{assigns: assigns} = conn, _opts) do
    case assigns[:current_user] do
      nil ->
        index_path = RecruitmentWeb.Router.Helpers.page_path(conn, :index)

        conn
        |> Recruit.signout
        |> Phoenix.Controller.redirect(to: index_path)
        |> halt
        
      _ -> 
        conn
    end
  end
end