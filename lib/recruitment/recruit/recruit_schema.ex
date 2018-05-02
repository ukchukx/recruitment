defmodule Recruitment.Recruit.Recruit do
  use Ecto.Schema
  import Ecto.Changeset
  alias Recruitment.Recruit.{
    PersonalDetail,
    WorkExperience,
    ProfessionalQualification,
    Attachment,
    EducationalQualification
  }


  schema "recruit" do
    field :email, :string
    field :fname, :string
    field :completed, :integer, default: 0
    field :application_stage, :integer, default: 0
    field :password, :string
    field :sname, :string
    has_one :personal_detail, PersonalDetail
    has_many :educational_qualification, EducationalQualification
    has_many :professional_qualification, ProfessionalQualification
    has_many :work_experience, WorkExperience
    has_many :attachment, Attachment

    timestamps()
  end

  @doc false
  def changeset(data, attrs) do
    data
    |> cast(attrs, [:fname, :sname, :email, :password, :completed, :application_stage])
    |> validate_required([:fname, :sname, :email, :password])
    |> put_pass_hash
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(pass))

      _ -> 
        changeset
    end
  end
end
