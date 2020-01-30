defmodule YellrWeb.PageControllerTest do
  use YellrWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Yellr"
  end
end
