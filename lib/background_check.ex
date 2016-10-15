defmodule BackgroundCheck do
	import Ecto.Query
	alias EagleEye.Repo
	alias EagleEye.Candidate
	alias EagleEye.Order

	@default_cost 24.99
	
	# find a way to make a protocol to make the calls via various APIs polymorphic
	# right now just using pattern matching with functions for the different potential background check vendors

	def get_candidate(:pab, ssn) do
		Repo.one(from c in Candidate, where: c.ssn == ^Base.encode64(ssn))
			|> Map.fetch!(:candidate_id)
			|> PAccurateBackground.get_candidate
			|> PAccurateBackground.new
	end

	def new_candidate(:pab) do
		pac = %{dateOfBirth: "1972-05-24",
						email: "waynerichardsllc@gmail.com",
						firstName: "Hoor",
						lastName: "Test",
						phone: "206-555-1212",
						ssn: "531901251",
						address: "2117 Elm Street",
						city: "Elk Grove",
						region: "CA",
						country: "US",
						postalCode: "95758"}

		{:ok, response} = PAccurateBackground.post_new_candidate(PAccurateBackground.new(pac)) 
		candidate = response.body |> JSON.decode!
		
		Repo.insert(%Candidate{
					first_name: Map.fetch!(candidate,"firstName"), 
					last_name: Map.fetch!(candidate,"lastName"), 
					candidate_id: Map.fetch!(candidate,"id"), 
					ssn: Base.encode64(Map.fetch!(candidate,"ssn"))
						})
	end

	def edit_candidate(:pab, ssn) do
		edit_map = %{} #need to define a map of the things that need changing. Then passes it along to pab
		
		get_candidate(:pab, ssn)
			|> PAccurateBackground.put_edit_candidate(edit_map) 
		
	end

	def new_order(:pab, ssn, cost \\ @default_cost) do
		pac = get_candidate(:pab, ssn)
		fk_cid = Repo.one(from c in Candidate, where: c.ssn == ^Base.encode64(ssn)) |> Map.fetch!(:id)  #redundant, has to be a better way to do this
													
		{:ok, response} = PAccurateBackground.post_order(pac)
		order = response.body |> JSON.decode!
		
		Repo.insert(%Order{
					candidate_id: fk_cid,
					order_id: Map.fetch!(order,"id"),
					ee_cost: cost
						})
	end

	def get_order_status(:pab, oid) do
	end
end
