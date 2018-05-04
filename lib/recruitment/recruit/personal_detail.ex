defmodule Recruitment.Recruit.PersonalDetail do
  use Ecto.Schema
  import Ecto.Changeset
  alias Recruitment.Recruit.Recruit

  @fields [:title, :mname, :gender, :nationality, :dob, :height, :nin, :phone, :permAddress, :permStreet, :permLga, 
      :permState, :curAddress, :curStreet, :curLga, :curState, :prefAddress, :stage, :age, :status, :recruit_id]

  schema "personal_details" do
    field :curAddress, :string
    field :curLga, :string
    field :curState, :string
    field :curStreet, :string
    field :dob, :string
    field :gender, :string
    field :height, :string
    field :mname, :string
    field :nationality, :string
    field :nin, :string
    field :permAddress, :string
    field :permLga, :string
    field :permState, :string
    field :permStreet, :string
    field :phone, :string
    field :prefAddress, :string
    field :age, :integer
    field :stage, :integer, default: 0
    field :status, :integer, default: 0
    field :title, :string
    belongs_to :recruit, Recruit
  end

  @doc false
  def changeset(personal_detail, attrs) do
    personal_detail
    |> cast(attrs, @fields)
  end
end
