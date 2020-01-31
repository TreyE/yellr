defmodule YellrWeb.SessionsView do
  use YellrWeb, :view

  def create_session_url(conn) do
    Routes.sessions_path(conn, :create)
  end
end
