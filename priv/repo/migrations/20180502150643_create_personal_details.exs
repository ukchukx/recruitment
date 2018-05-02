defmodule Recruitment.Repo.Migrations.CreatePersonalDetails do
  use Ecto.Migration

  def change do
    create table(:personal_details) do
      add :title, :string
      add :mname, :string
      add :gender, :string
      add :nationality, :string
      add :dob, :string
      add :height, :string
      add :nin, :string
      add :phone, :string
      add :permAddress, :string
      add :permStreet, :string
      add :permLga, :string
      add :permState, :string
      add :curAddress, :string
      add :curStreet, :string
      add :curLga, :string
      add :curState, :string
      add :prefAddress, :string
      add :completed, :integer
      add :accepted, :integer
      add :denied, :integer
      add :verified, :integer
      add :status, :integer
      add :recruit_id, references(:recruit, on_delete: :nothing)

      timestamps()
    end

    create index(:personal_details, [:recruit_id])
  end
end
