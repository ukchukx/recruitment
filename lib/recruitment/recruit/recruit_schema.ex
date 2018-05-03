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

  @fields [:fname, :sname, :email, :password, :completed, :application_stage, :position_category,
    :position_applied_for, :accepted, :denied, :verified, :cg_approval, :reference]


  schema "recruit" do
    field :email, :string
    field :fname, :string
    field :sname, :string
    field :reference, :string, default: ""
    field :position_category, :integer, default: 0
    field :position_applied_for, :integer, default: 0
    field :accepted, :integer, default: 0
    field :denied, :integer, default: 0
    field :verified, :integer, default: 0
    field :cg_approval, :integer, default: 0
    field :completed, :integer, default: 0
    field :application_stage, :integer, default: 0
    field :password, :string
    has_one :personal_detail, PersonalDetail
    has_many :educational_qualifications, EducationalQualification
    has_many :professional_qualifications, ProfessionalQualification
    has_many :work_experience, WorkExperience
    has_many :attachments, Attachment
  end

  @doc false
  def changeset(data, attrs) do
    data
    |> cast(attrs, @fields)
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
