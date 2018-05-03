defmodule Recruitment.Recruit.Country do
  use Ecto.Schema
  import Ecto.Changeset


  schema "countries" do
    field :name, :string
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
