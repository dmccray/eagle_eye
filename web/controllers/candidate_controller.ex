defmodule EagleEye.CandidateController do
	use EagleEye.Web, :controller
	alias EagleEye.Candidate
	alias EagleEye.Order
	alias EagleEye.Organization

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
		orders = Repo.all(from o in Order, where: o.candidate_id == ^id)
		render conn, "show.html", candidate: candidate, orders: orders
	end

	def new(conn, _params) do
		changeset = Candidate.changeset(%Candidate{})
		organizations = Repo.all(from o in Organization, select: {o.name, o.id})

		#changeset = candidate |> Ecto.build_assoc(:orders) |> Order.changeset(order_db_columns)
		
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
end

