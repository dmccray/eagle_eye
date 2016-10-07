defmodule EagleEye.PageController do
  use EagleEye.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
