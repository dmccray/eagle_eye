defmodule EagleEye.Organization do
	use EagleEye.Web, :model 

	schema "organizations" do
		field :name, :string

		#has_one :candidate, EagleEye.Candidate
		timestamps
	end
end
