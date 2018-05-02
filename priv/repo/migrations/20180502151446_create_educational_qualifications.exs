defmodule Recruitment.Repo.Migrations.CreateEducationalQualifications do
  use Ecto.Migration

  def change do
    create table(:educational_qualifications) do
      add :startdate, :string
      add :enddate, :string
      add :course_of_study, :string
      add :qualification, :string
      add :type, :string
      add :classification, :string
      add :institution, :string
      add :city, :string
      add :country, :string
      add :recruit_id, references(:recruit, on_delete: :nothing)

      timestamps()
    end

    create index(:educational_qualifications, [:recruit_id])
  end
end
