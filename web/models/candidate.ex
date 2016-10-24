defmodule EagleEye.Candidate do
	use EagleEye.Web, :model 

	schema "candidates" do
		field :firstName, :string
		field :lastName, :string
		field :candidate_id, :string
		field :ssn, :string

		belongs_to :organization, EagleEye.Organization #the belongs_to inserts the fk organization_id
		has_many :orders, EagleEye.Order
		timestamps
	end

	def changeset(model, params \\ %{}) do
		model
		|> cast(params, ~w(firstName lastName ssn candidate_id organization_id))
		|> cast_assoc(:orders, required: false)
		#validate_length(:ssn, min: 9, max: 9)
	end

end
