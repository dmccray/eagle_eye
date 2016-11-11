defmodule EagleEye.SessionController do
	use EagleEye.Web, :controller
	alias EagleEye.Candidate

	def new(conn, _) do
		case get_session(conn, :user_id) do
			nil ->
				render conn, "new.html"
			_ ->
				query =
				from c in Candidate,
				left_join: o in assoc(c, :organization),
				preload: :organization,
				order_by: [asc: o.name, desc: c.id]

				candidates = Repo.all(query)
				
				render conn, EagleEye.CandidateView, "index.html", candidates: candidates
		end
	end

	def delete(conn, _) do
		conn
		|> EagleEye.Auth.logout()
		|> redirect(to: session_path(conn, :new))
	end
		
	def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
		case EagleEye.Auth.login_by_username_and_pass(conn, user, pass, repo: EagleEye.Repo) do
			{:ok, conn} ->
				conn
				|> put_flash(:info, "Logged in.")
				|> redirect(to: candidate_path(conn, :index))
			{:error, _reason, conn} ->
				conn
				|> put_flash(:error, "Invalid username/password.")
				|> render("new.html")
		end
	end
end
