defmodule Recruitment.Recruit.ProfessionalQualification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Recruitment.Recruit.Recruit


  schema "professional_qualifications" do
    field :city, :string
    field :country, :string
    field :enddate, :string
    field :certificate_title, :string
    field :grade, :string
    field :highest_qual, :string
    field :institution, :string
    field :level, :string
    field :qualification, :string
    field :reg_no, :string
    field :startdate, :string
    belongs_to :recruit, Recruit
  end

  @doc false
  def changeset(professional_qualification, attrs) do
    professional_qualification
    |> cast(attrs, [:startdate, :enddate, :qualification, :reg_no, :certificate_title, :institution, :city, :country, :level, :grade, :highest_qual, :recruit_id])
  end
end
