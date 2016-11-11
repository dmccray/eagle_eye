defmodule EagleEye.SessionController do
	use EagleEye.Web, :controller

	def new(conn, _) do
		render conn, "new.html"
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
				> render("new.html")
		end
	end
end
