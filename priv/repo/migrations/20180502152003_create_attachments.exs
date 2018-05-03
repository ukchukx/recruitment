defmodule Recruitment.Repo.Migrations.CreateAttachments do
  use Ecto.Migration

  def change do
    create table(:attachments) do
      add :title, :string
      add :path, :string
      add :file_type, :string
      add :recruit_id, references(:recruit, on_delete: :nothing)
    end

    create index(:attachments, [:recruit_id])
  end
end
