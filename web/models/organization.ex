defmodule EagleEye.Organization do
	use EagleEye.Web, :model 

	schema "organizations" do
		field :name, :string

		timestamps
	end

	def changeset(model, params \\ %{}) do
		model
		|> cast(params, ~w(name))
	end

	
end
