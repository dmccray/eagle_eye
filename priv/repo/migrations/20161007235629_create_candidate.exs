defmodule EagleEye.Repo.Migrations.CreateCandidate do
  use Ecto.Migration

  def change do
  	create table(:candidates) do
  		add :first_name, :string
  		add :last_name, :string
  		add :candidate_id, :string
  		add :ssn, :string

  		timestamps
  	end

  	create unique_index(:candidates, [:candidate_id])
  end
end
