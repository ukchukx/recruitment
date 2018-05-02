defmodule Recruitment.Recruit.Lga do
  use Ecto.Schema
  import Ecto.Changeset


  schema "lgas" do
    field :name, :string
    field :state, :string

    timestamps()
  end

  @doc false
  def changeset(lga, attrs) do
    lga
    |> cast(attrs, [:state, :name])
    |> validate_required([:state, :name])
  end
end
