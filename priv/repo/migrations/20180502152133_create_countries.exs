defmodule Recruitment.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string

      timestamps()
    end

  end
end
