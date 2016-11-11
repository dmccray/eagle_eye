defmodule EagleEye.CandidateController do
	use EagleEye.Web, :controller
	alias EagleEye.Candidate
	alias EagleEye.Order
	alias EagleEye.Organization

	plug :authenticate when action in [:index, :show, :new, :create]

	def login(conn, _params) do
		render conn, "login.html"
	end
	
	def index(conn, _params) do
		query =
			from c in Candidate,
			left_join: o in assoc(c, :organization),
			preload: :organization,
			order_by: [asc: o.name, desc: c.id]

		candidates = Repo.all(query)
		render conn, "index.html", candidates: candidates
	end

	def show(conn, %{"id" => id}) do
		candidate = Repo.get(Candidate, id)
		candidate_from_api = BackgroundCheck.get_candidate(:pab, candidate.candidate_id)
		orders = Repo.all(from o in Order, where: o.candidate_id == ^id)
		
		render conn, "show.html", candidate: candidate, candidate_from_api: candidate_from_api.candidate, orders: orders
	end

	def new(conn, _params) do
		changeset = Candidate.changeset(%Candidate{})
		organizations = Repo.all(from o in Organization, select: {o.name, o.id})
		
		render conn, "new.html", changeset: changeset, organizations: organizations
	end

	def create(conn, %{"candidate" => candidate_params}) do
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

	defp authenticate(conn, _opts) do
		if conn.assigns.current_user do
			conn
		else
			conn
			|> put_flash(:error, "You must be logged in to access.")
			|> redirect(to: session_path(conn, :new))
			|> halt()
		end
	end
end

