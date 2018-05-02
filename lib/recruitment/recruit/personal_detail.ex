defmodule Recruitment.Recruit.PersonalDetail do
  use Ecto.Schema
  import Ecto.Changeset
  alias Recruitment.Recruit.Recruit


  schema "personal_details" do
    field :accepted, :integer, default: 0
    field :completed, :integer, default: 0
    field :curAddress, :string
    field :curLga, :string
    field :curState, :string
    field :curStreet, :string
    field :denied, :integer, default: 0
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
    field :status, :integer, default: 0
    field :title, :string
    field :verified, :integer, default: 0
    belongs_to :recruit, Recruit

    timestamps()
  end

  @doc false
  def changeset(personal_detail, attrs) do
    personal_detail
    |> cast(attrs, [:title, :mname, :gender, :nationality, :dob, :height, :nin, :phone, :permAddress, :permStreet, :permLga, :permState, :curAddress, :curStreet, :curLga, :curState, :prefAddress, :completed, :accepted, :denied, :verified, :status])
  end
end
