defmodule Recruitment.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def change do
    create table(:positions) do
      add :title, :string
      add :short_code, :string
      add :status, :integer
    end

  end
end
