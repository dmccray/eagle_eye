defmodule EagleEye.Candidate do
	use EagleEye.Web, :model 

	schema "candidates" do
		field :first_name, :string
		field :last_name, :string
		field :candidate_id, :string
		field :ssn, :string

		has_many :orders, EagleEye.Order
		timestamps
	end
end
