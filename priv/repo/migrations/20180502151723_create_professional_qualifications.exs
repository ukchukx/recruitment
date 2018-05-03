defmodule Recruitment.Repo.Migrations.CreateProfessionalQualifications do
  use Ecto.Migration

  def change do
    create table(:professional_qualifications) do
      add :startdate, :string
      add :enddate, :string
      add :qualification, :string
      add :reg_no, :string
      add :certificate_title, :string
      add :institution, :string
      add :city, :string
      add :country, :string
      add :level, :string
      add :grade, :string
      add :highest_qual, :string
      add :recruit_id, references(:recruit, on_delete: :nothing)
    end

    create index(:professional_qualifications, [:recruit_id])
  end
end
