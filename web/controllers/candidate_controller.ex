defmodule EagleEye.CandidateController do
	use EagleEye.Web, :controller
	alias EagleEye.Candidate
	alias EagleEye.Order
	alias EagleEye.Organization

	def index(conn, _params) do
		candidates = Repo.all(Candidate)
		render conn, "index.html", candidates: candidates
	end

	def show(conn, %{"id" => id}) do
		candidate = Repo.get(Candidate, id)
		orders = Repo.all(from o in Order, where: o.candidate_id == ^id)
		render conn, "show.html", candidate: candidate, orders: orders
	end

	def new(conn, _params) do
		changeset = Candidate.changeset(%Candidate{})
		#organizations = Repo.all(from o in Organization, select: {o.id, o.name})
		
		render conn, "new.html", changeset: changeset
	end

	def create(conn, %{"candidate" => candidate_params}) do
		#bc_candidate = candidate_params		#should be all fields available from the form
		#changeset = Candidate.changeset(%Candidate{}, Map.take(candidate_params, ["first_name", "last_name", "ssn"]))
		
		case BackgroundCheck.new_candidate(:pab, candidate_params) do
			{:ok, candidate} ->	
				conn
				|> put_flash(:info, "#{candidate.firstName} #{candidate.lastName} created!")
				|> redirect(to: candidate_path(conn, :index))

			{:error, reason} ->
				conn
				|> put_flash(:error, "candidate not created!")
				|> redirect(to: candidate_path(conn, :index))
		end
	end
end

