defmodule Recruitment.Recruit.WorkExperience do
  use Ecto.Schema
  import Ecto.Changeset
  alias Recruitment.Recruit.Recruit


  schema "work_experience" do
    field :enddate, :string
    field :organization, :string
    field :role, :string
    field :startdate, :string
    belongs_to :recruit, Recruit

    timestamps()
  end

  @doc false
  def changeset(work_experience, attrs) do
    work_experience
    |> cast(attrs, [:startdate, :enddate, :role, :organization])
  end
end
