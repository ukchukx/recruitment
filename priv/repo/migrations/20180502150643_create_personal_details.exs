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
      add :stage, :integer
      add :status, :integer
      add :age, :integer
      add :recruit_id, references(:recruit, on_delete: :nothing)
    end

    create index(:personal_details, [:recruit_id])
  end
end
