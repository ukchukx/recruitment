defmodule RecruitmentWeb.Plug.Auth do
  import Plug.Conn
  alias Recruitment.Recruit

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Recruit.get_recruit!(user_id)
    assign(conn, :current_user, user)
  end
end