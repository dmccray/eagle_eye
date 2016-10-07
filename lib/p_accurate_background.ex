defmodule PAccurateBackground do
	
	@ab_url 			"https://api.accuratebackground.com"
	@ab_host			"api.accuratebackground.com"
	@ab_version			"/v3"
	@ab_candidate		"/candidate"
	@ab_order			"/order"
	@ab_user			"65ba00d1-ea1f-4368-b6e2-eaf090548d9a"
	@ab_secret			"a3270456-0b17-4686-b013-a43b5c6eab6c"
	@ab_auth			Base.encode64(@ab_user <> ":" <> @ab_secret)
	@ab_headers			%{"Content-Type" => "application/json", "Authorization" => @ab_auth}
	@ab_headers_put 	%{"Content-Type" => "application/x-www-form-urlencoded", "Authorization" => @ab_auth}
	@ab_options			%{"host" => "api.accuratebackground.com", "port" => 443, "path" => "/v3/candidate", "headers" => @ab_headers}
	@ab_options_put		%{"host" => "api.accuratebackground.com", "port" => 443, "path" => "/v3/candidate", "headers" => @ab_headers_put}

	#struct to pass in new candidate information
	defstruct candidate: %{}		

	def new(c) do
		%PAccurateBackground{candidate: c}
	end

	def get_candidate(cid) do
		start_http_request

		response = HTTPoison.get!(@ab_url <> @ab_version <> @ab_candidate <> "/" <> cid, Map.to_list(@ab_headers), Map.to_list(@ab_options))
		response.body
			|> JSON.decode!
	end

	def post_new_candidate(s) do 					#expecting a struct %PAccurateBackground(candidate: c)
		start_http_request
		HTTPoison.post!(@ab_url <> @ab_version <> @ab_candidate, JSON.encode!(Map.to_list(s.candidate)), Map.to_list(@ab_headers), Map.to_list(@ab_options))
	end
	
	def put_edit_candidate(cid, edit_map) do
		edit_string = List.foldl(Map.to_list(edit_map), "", fn(x, acc) -> acc <> to_string(elem(x,0)) <> "=" <> String.replace(elem(x,1), " ", "+") <> "&" end) |> String.trim("&")		#converts map into a string of parameters of format "address=1492+Elm+St&city=San+Jose&country=US&postalCode=95123&region=CA&"

		start_http_request
		response = HTTPoison.put!(@ab_url <> @ab_version <> @ab_candidate <> "/" <> cid, edit_string, Map.to_list(@ab_headers_put), Map.to_list(@ab_options_put))
		response.body
			|> JSON.decode!
	end

	def post_order(cid) do #need additional parameters for the options
		order_details = %{candidateId: cid, packageType: "PKG_EMPTY", workflow: "EXPRESS", copyOfReport: "true", jobLocation: %{country: "US", region: "CA", city: "Irvine"}}

		start_http_request
		response = HTTPoison.post!(@ab_url <> @ab_version <> @ab_order, JSON.encode!(Map.to_list(order_details)), Map.to_list(@ab_headers), Map.to_list(@ab_options))
		response.body
			|> JSON.decode!
	end

	def get_order_status(oid) do
		start_http_request
		response = HTTPoison.get!(@ab_url <> @ab_version <> @ab_order <> "/" <> oid, Map.to_list(@ab_headers), Map.to_list(@ab_options))
		response.body
			|> JSON.decode!
	end

	defp start_http_request, do: HTTPoison.start()
end