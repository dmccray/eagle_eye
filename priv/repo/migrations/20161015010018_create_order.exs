defmodule EagleEye.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
		create table(:orders) do
			add :candidate_id, references :candidates
			add :order_id, :string
			add :ee_cost, :float

			timestamps
		end

		create unique_index(:orders, [:order_id])
	end
end
