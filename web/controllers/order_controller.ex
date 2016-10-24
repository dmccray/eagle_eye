defmodule EagleEye.OrderController do
	use EagleEye.Web, :controller
	alias EagleEye.Candidate
	alias EagleEye.Order

	def new(conn, _params) do
		
		candidate = Repo.get!(Candidate, Map.fetch!(_params, "candidate_id"))
		
		changeset = Order.changeset(%Order{})
		#changeset = Candidate.changeset(%Candidate{orders: [%Order{}]})

		render conn, "new.html", changeset: changeset, candidate: candidate
	end

	def create(conn, %{"order" => order_params, "candidate_id" => candidate_id}) do
		case BackgroundCheck.new_order(:pab, candidate_id, order_params) do
			{:ok, order} ->
				conn
				|> put_flash(:info, "Record created!")
				|> redirect(to: candidate_path(conn, :show, candidate_id))
			{:error, reason} ->
				conn
				|> put_flash(:error, "order not created!")
				|> redirect(to: candidate_path(conn, :show, candidate_id, changeset: reason))
		end
	end
end
