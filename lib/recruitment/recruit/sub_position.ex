defmodule Recruitment.Recruit.SubPosition do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:sub_position_id, :id, []}
  schema "sub_positions" do
    field :hint, :string
    field :status, :integer
    field :sub_title, :string
    field :position_id, :id
  end

  @doc false
  def changeset(sub_position, attrs) do
    sub_position
    |> cast(attrs, [:position_id, :sub_title, :hint, :status])
  end
end
