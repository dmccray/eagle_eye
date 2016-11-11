defmodule EagleEye.OrganizationController do
	use EagleEye.Web, :controller
	alias EagleEye.Organization

	plug :authenticate when action in [:index, :show, :new, :create]
	
	def index(conn, _params) do
		organizations = Repo.all(Organization)
		
		render conn, "index.html", organizations: organizations
	end

	def show(conn, %{"id" => id}) do
		organization = Repo.get(Organization, id)
		render conn, "show.html", organization: organization
	end

	
	def new(conn, _params) do
		changeset = Organization.changeset(%Organization{})
		render conn, "new.html", changeset: changeset
	end

	def create(conn, %{"organization" => organization_params}) do
		changeset = Organization.changeset(%Organization{}, organization_params)

		case Repo.insert(changeset) do
			{:ok, organization} ->
				conn
				|> put_flash(:info, "#{organization.name} created!")
				|> redirect(to: organization_path(conn, :index))
			{:error, reason} ->
				conn
				|> put_flash(:error, "organization not created!")
				|> redirect(to: organization_path(conn, :index))
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
