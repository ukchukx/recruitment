defmodule Recruitment.Recruit.Lga do
  use Ecto.Schema
  import Ecto.Changeset


  schema "lgas" do
    field :name, :string
    field :state, :string
    field :state_short_code, :string
  end

  @doc false
  def changeset(lga, attrs) do
    lga
    |> cast(attrs, [:state, :name, :state_short_code])
    |> validate_required([:state, :name, :state_short_code])
  end
end
