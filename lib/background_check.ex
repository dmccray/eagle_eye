defmodule BackgroundCheck do
	import Ecto.Query
	alias EagleEye.Repo
	alias EagleEye.Candidate

	# find a way to make a protocol to make the calls via various APIs polymorphic

	def get_candidate(:pab, ssn) do
		Repo.one(from c in Candidate, where: c.ssn == ^Base.encode64(ssn))
			|> Map.fetch!(:candidate_id)
			|> PAccurateBackground.get_candidate
	end

	def new_candidate(:pab) do
		pac = %{dateOfBirth: "1972-05-24", email: "waynerichardsllc@gmail.com",  firstName: "Shmee", lastName: "Test", phone: "206-555-1212", ssn: "531901243", address: "2117 Elm Street", city: "Elk Grove", region: "CA", country: "US", postalCode: "95758"}

		{:ok, response} = PAccurateBackground.post_new_candidate(PAccurateBackground.new(pac)) 
		candidate = response.body |> JSON.decode!
		Repo.insert(%Candidate{first_name: Map.fetch!(candidate,"firstName"), 
								last_name: Map.fetch!(candidate,"lastName"), 
								candidate_id: Map.fetch!(candidate,"id"), 
								ssn: Base.encode64(Map.fetch!(candidate,"ssn"))})
	end

	def edit_candidate(:pab, cid) do
	end

	def new_order(:pab, cid) do
	end

	def get_order_status(:pab, oid) do
	end
end