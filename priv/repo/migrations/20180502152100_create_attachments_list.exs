defmodule Recruitment.Repo.Migrations.CreateAttachmentsList do
  use Ecto.Migration

  def change do
    create table(:attachments_list) do
      add :degree, :string
      add :status, :integer
    end

  end
end
