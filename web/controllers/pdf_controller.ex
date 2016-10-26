defmodule EagleEye.PdfController do
	use EagleEye.Web, :controller
	alias EagleEye.Candidate
	alias EagleEye.Order
	alias EagleEye.Organization

	def export(conn, %{"candidate_id" => candidate_id, "order_id" => order_id}) do
		candidate = EagleEye.Repo.get(Candidate, candidate_id) #so far no need to preload
		candidate_from_api = BackgroundCheck.get_candidate(:pab, candidate.candidate_id)
		order = EagleEye.Repo.get(Order, order_id)
		order_from_api = BackgroundCheck.get_order_status(:pab, order.order_id)

		html = Phoenix.View.render_to_string(EagleEye.PdfView,
																				 "export.html",
																				 [candidate: candidate,
																					candidate_from_api: candidate_from_api.candidate,
																					order: order,
																					order_from_api: order_from_api,
																					conn: conn])

		current_date_time =	:calendar.local_time() |> Ecto.DateTime.cast! |> Ecto.DateTime.to_string
		
		conn
		|> put_resp_content_type("text/pdf")
    |> put_resp_header("Content-Disposition", "attachment; filename=\"Eagle Eye Report - #{order.order_id} - #{current_date_time}.pdf\"")
    |> send_resp(200, create_pdf(html))
	end

	defp create_pdf(html) do
		IO.puts html
		
		PdfGenerator.generate_binary!(html, delete_temporary: true)
	end
	
end
