defmodule EagleEye.Order do
	use EagleEye.Web, :model

	schema "orders" do
		field :order_id, :string
		field :ee_cost, :float

		belongs_to :candidate, EagleEye.Candidate
		timestamps
	end

	def changeset(model, params \\ %{}) do
		model
		|> cast(params, ~w(order_id candidate_id ee_cost))
		#|> cast_assoc(:candidate, required: true)
	end

end
