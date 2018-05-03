defmodule Recruitment.Recruit.Position do
  use Ecto.Schema
  import Ecto.Changeset


  schema "positions" do
    field :short_code, :string
    field :status, :integer
    field :title, :string
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [:title, :short_code, :status])
    |> validate_required([:title, :short_code, :status])
  end
end
