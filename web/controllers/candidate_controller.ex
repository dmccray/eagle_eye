defmodule EagleEye.CandidateController do
	use EagleEye.Web, :controller

	def index(conn, _params) do
		candidates = Repo.all(EagleEye.Candidate)
		render conn, "index.html", candidates: candidates
	end

	def show(conn, %{"id" => id}) do
		candidate = Repo.get(EagleEye.Candidate, id)
		orders = Repo.all(from o in EagleEye.Order, where: o.candidate_id == ^id)
		render conn, "show.html", candidate: candidate, orders: orders
	end


end

