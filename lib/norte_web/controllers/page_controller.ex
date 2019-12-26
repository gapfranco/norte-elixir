defmodule NorteWeb.PageController do
  use NorteWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
