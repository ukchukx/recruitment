defmodule Recruitment.Recruit.Attachment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Recruitment.Recruit.Recruit


  schema "attachments" do
    field :path, :string
    field :title, :string
    belongs_to :recruit, Recruit

    timestamps()
  end

  @doc false
  def changeset(attachment, attrs) do
    attachment
    |> cast(attrs, [:title, :path])
  end
end
