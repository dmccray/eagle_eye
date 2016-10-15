defmodule EagleEye.Order do
	use EagleEye.Web, :model

	schema "orders" do
		field :order_id, :string
		field :ee_cost, :float

		belongs_to :candidate, EagleEye.Candidate
		timestamps
	end
end
