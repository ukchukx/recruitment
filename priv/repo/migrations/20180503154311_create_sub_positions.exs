defmodule Recruitment.Repo.Migrations.CreateSubPositions do
  use Ecto.Migration

  def change do
    create table(:sub_positions, primary_key: false) do
      add :sub_position_id, :id, primary_key: true
      add :sub_title, :string
      add :hint, :string
      add :status, :integer
      add :position_id, references(:positions, on_delete: :nothing)
    end

    create index(:sub_positions, [:position_id])
  end
end
