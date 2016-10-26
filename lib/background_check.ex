defmodule BackgroundCheck do
	import Ecto.Query
	alias EagleEye.Repo
	alias EagleEye.Candidate
	alias EagleEye.Order

	@default_cost 24.99
	
	# find a way to make a protocol to make the calls via various APIs polymorphic
	# right now just using pattern matching with functions for the different potential background check vendors

	def get_candidate(:pab, cid) do
		cid
		|> PAccurateBackground.get_candidate
		|> PAccurateBackground.new
	end

	def new_candidate(:pab, pac \\ %{}) do
		case PAccurateBackground.post_new_candidate(PAccurateBackground.new(pac)) do
			{:ok, response} -> 
				candidate = response.body |> JSON.decode!
				candidate_db_columns = 	Map.put(pac, "candidate_id", Map.fetch!(candidate, "id"))
				|> Map.take(["firstName", "lastName", "ssn", "candidate_id", "organization_id"])
				|> Map.update!("ssn", &(Base.encode64(&1)))

				changeset = Candidate.changeset(%Candidate{}, candidate_db_columns)
				Repo.insert(changeset)
		end
	end

	def edit_candidate(:pab, cid, edit_map \\ %{}) do
		pac = get_candidate(:pab, cid)

		{:ok, response} = PAccurateBackground.put_edit_candidate(pac, edit_map)
		candidate = response.body |> JSON.decode!

		#here we should update any info we have for the candidate (i.e. SSN, name). use Ecto Changesets. Future enhancement.
	end

	def new_order(:pab, candidate_id, order_params) do
		#getting data from the DB
		candidate = Repo.get!(Candidate, candidate_id) |> Repo.preload([:orders, :organization])

		#getting data from the API
		pac = get_candidate(:pab, candidate.candidate_id)

		#getting the job location from order_params
		jlm = %{%{country: nil, region: nil, city: nil} |
						country: order_params["job_location_country"],
						region: order_params["job_location_region"],
						city: order_params["job_location_city"]}
		
		case PAccurateBackground.post_order(pac, "PKG_EMPTY", "EXPRESS", "true", jlm) do	#check out API documentation for order  options
			{:ok, response} ->
				order = response.body |> JSON.decode!
				order_db_columns = Map.put(order, "order_id", Map.fetch!(order, "id"))
				|> Map.put("ee_cost", Map.fetch!(order_params, "ee_cost"))
				|> Map.take(["order_id", "ee_cost"])

				#this is the correct way to associate and save a model
				changeset = candidate |> Ecto.build_assoc(:orders) |> Order.changeset(order_db_columns)
				
				Repo.insert(changeset)
		end
	end

	def get_order_status(:pab, oid) do
		PAccurateBackground.get_order_status(oid)
	end
end
