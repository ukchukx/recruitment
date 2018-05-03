defmodule RecruitmentWeb.PageView do
  use RecruitmentWeb, :view

  def csrf_token(_conn) do 
    Plug.CSRFProtection.get_csrf_token()
  end

  def years_from(start_year), do: Enum.to_list(start_year..Date.utc_today().year)
end
