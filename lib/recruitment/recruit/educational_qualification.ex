defmodule Recruitment.Recruit.EducationalQualification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Recruitment.Recruit.Recruit


  schema "educational_qualifications" do
    field :city, :string
    field :classification, :string
    field :country, :string
    field :course_of_study, :string, default: ""
    field :enddate, :string
    field :institution, :string
    field :qualification, :string
    field :startdate, :string
    field :type, :string
    belongs_to :recruit, Recruit
  end

  @doc false
  def changeset(educational_qualification, attrs) do
    educational_qualification
    |> cast(attrs, [:startdate, :enddate, :course_of_study, :qualification, :type, :classification, :institution, :city, :country, :recruit_id])
  end
end
