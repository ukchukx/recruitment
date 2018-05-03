defmodule Recruitment.Repo.Migrations.CreateRecruit do
  use Ecto.Migration

  def change do
    create table(:recruit) do
      add :fname, :string
      add :sname, :string
      add :email, :string
      add :password, :string
      add :reference, :string
      add :completed, :integer
      add :application_stage, :integer
      add :position_category, :integer
      add :position_applied_for, :integer
      add :accepted, :integer
      add :denied, :integer
      add :verified, :integer
      add :cg_approval, :integer
    end
    create index(:recruit, [:email])
  end
end
