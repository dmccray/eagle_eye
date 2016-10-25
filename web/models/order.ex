defmodule EagleEye.Order do
	use EagleEye.Web, :model

	schema "orders" do
		field :order_id, :string
		field :ee_cost, :float
		field :job_location_city, :string, virtual: true
		field :job_location_region, :string, virtual: true
		field :job_location_country, :string, virtual: true
		
		belongs_to :candidate, EagleEye.Candidate
		timestamps
	end

	def changeset(model, params \\ %{}) do
		model
		|> cast(params, ~w(order_id candidate_id ee_cost job_location_city job_location_region job_location_country))
		#|> cast_assoc(:candidate, required: true)
	end

end
