defmodule Recruitment.Recruit.Attachment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Recruitment.Recruit.Recruit


  schema "attachments" do
    field :path, :string
    field :title, :string
    field :file_type, :string
    belongs_to :recruit, Recruit
  end

  @doc false
  def changeset(attachment, attrs) do
    attachment
    |> cast(attrs, [:title, :path, :recruit_id])
  end
end
