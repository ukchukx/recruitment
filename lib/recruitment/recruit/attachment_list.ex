defmodule Recruitment.Recruit.AttachmentList do
  use Ecto.Schema
  import Ecto.Changeset


  schema "attachments_list" do
    field :degree, :string
    field :status, :string
  end

  @doc false
  def changeset(attachment_list, attrs) do
    attachment_list
    |> cast(attrs, [:degree, :status])
    |> validate_required([:degree, :status])
  end
end
