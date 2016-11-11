defmodule EagleEye.OrderController do
	use EagleEye.Web, :controller
	alias EagleEye.Candidate
	alias EagleEye.Order

	plug :authenticate when action in [:index, :show, :new, :create]
	
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
				|> put_flash(:info, "Order created!")
				|> redirect(to: candidate_path(conn, :show, candidate_id))
			{:error, reason} ->
				conn
				|> put_flash(:error, "Order not created!")
				|> redirect(to: candidate_path(conn, :show, candidate_id, changeset: reason))
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
