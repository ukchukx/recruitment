defmodule Recruitment.Recruit.ResultClassification do
  use Ecto.Schema
  import Ecto.Changeset


  schema "result_classifications" do
    field :classification, :string
    field :status, :integer
  end

  @doc false
  def changeset(result_classification, attrs) do
    result_classification
    |> cast(attrs, [:classification, :status])
  end
end
