defmodule EagleEye.CandidateView do
	use EagleEye.Web, :view
	alias EagleEye.Repo
	alias EagleEye.Organization
	
	def get_organization_name(org_id) do
		Repo.get!(Organization, org_id)
	end
end
