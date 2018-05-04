defmodule RecruitmentWeb.ApiView do
  use RecruitmentWeb, :view

  def render("result.json", %{result: result}), do: result 
end