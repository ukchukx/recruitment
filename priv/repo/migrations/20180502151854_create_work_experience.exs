defmodule Recruitment.Repo.Migrations.CreateWorkExperience do
  use Ecto.Migration

  def change do
    create table(:work_experience) do
      add :startdate, :string
      add :enddate, :string
      add :role, :string
      add :organization, :string
      add :recruit_id, references(:recruit, on_delete: :nothing)
    end

    create index(:work_experience, [:recruit_id])
  end
end
