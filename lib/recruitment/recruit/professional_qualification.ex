defmodule Recruitment.Recruit.ProfessionalQualification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Recruitment.Recruit.Recruit


  schema "professional_qualifications" do
    field :city, :string
    field :classification, :string
    field :country, :string
    field :enddate, :string
    field :fos, :string
    field :grade, :string
    field :highest_qual, :string
    field :institution, :string
    field :level, :string
    field :qualification, :string
    field :reg_no, :string
    field :startdate, :string
    belongs_to :recruit, Recruit

    timestamps()
  end

  @doc false
  def changeset(professional_qualification, attrs) do
    professional_qualification
    |> cast(attrs, [:startdate, :enddate, :qualification, :reg_no, :classification, :institution, :city, :country, :level, :grade, :fos, :highest_qual])
    |> validate_required([:startdate, :enddate, :qualification, :reg_no, :classification, :institution, :city, :country, :level, :grade, :fos, :highest_qual])
  end
end
