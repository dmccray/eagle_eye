defmodule EagleEye.Repo.Migrations.CreateCandidate do
  use Ecto.Migration

  def change do
  	create table(:candidates) do
  		add :firstName, :string
  		add :lastName, :string
  		add :candidate_id, :string
  		add :ssn, :string
			add :organization_id, references :organizations

  		timestamps
  	end

  	create unique_index(:candidates, [:candidate_id])
  end
end
