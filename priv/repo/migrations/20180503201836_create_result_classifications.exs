defmodule Recruitment.Repo.Migrations.CreateResultClassifications do
  use Ecto.Migration

  def change do
    create table(:result_classifications) do
      add :classification, :string
      add :status, :integer
    end

  end
end
