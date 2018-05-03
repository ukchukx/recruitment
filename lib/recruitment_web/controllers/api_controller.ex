defmodule RecruitmentWeb.ApiController do
  use RecruitmentWeb, :controller
  require Logger

  alias Recruitment.Recruit

  def get_all_related_tables(conn, _) do
    render_result(conn, Recruit.get_all_related_tables())
  end

  def get_positions(conn, %{"id" => id}) do
    render_result(conn, Recruit.get_positions(id))
  end

  def get_qualifications(conn, %{"id" => id}) do
    render_result(conn, Recruit.get_qualifications(id))
  end

  def get_applicant_details(conn, %{"id" => id}) do
    render_result(conn, Recruit.get_applicant_details(id))
  end

  def delete_result(conn, %{"id" => id, "user_id" => user_id, "table" => table}) do
    case table do
      "professional" ->
        case Recruit.get_professional_qualification!(id) do
          %{recruit_id: ^user_id} = prof -> 
            Recruit.delete_professional_qualification(prof)
            send_resp(conn, :no_content, "")
          _ -> send_resp(conn, :forbidden, "not owner")
        end
        
      "qualification" ->
        case Recruit.get_educational_qualification!(id) do
          %{recruit_id: ^user_id} = edu -> 
            Recruit.delete_educational_qualification(edu)
            send_resp(conn, :no_content, "")
          _ -> send_resp(conn, :forbidden, "not owner")
        end

      _ -> send_resp(conn, :bad_request, "unknown table")
    end
    
  end

  defp render_result(conn, result) do
    conn
    |> put_status(:ok)
    |> render("result.json", result: result)
  end
end