defmodule Recruitment.Repo.Migrations.CreateRecruit do
  use Ecto.Migration

  def change do
    create table(:recruit) do
      add :fname, :string
      add :sname, :string
      add :email, :string
      add :completed, :integer
      add :application_stage, :integer
      add :password, :string

      timestamps()
    end
    create index(:recruit, [:email])
  end
end
