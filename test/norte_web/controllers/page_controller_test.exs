defmodule NorteWeb.PageControllerTest do
  use NorteWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Norte"
  end
end
