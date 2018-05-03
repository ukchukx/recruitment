defmodule Recruitment.Repo.Migrations.CreateLgas do
  use Ecto.Migration

  def change do
    create table(:lgas) do
      add :state, :string
      add :name, :string
      add :state_short_code, :string
    end

  end
end
