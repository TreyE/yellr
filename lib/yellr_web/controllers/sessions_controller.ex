defmodule YellrWeb.SessionsController do
  use YellrWeb, :controller

  alias Yellr.Authentication.Accounts

  def new(conn, _) do
    session = Accounts.new_session_changeset()
    render(conn, "new.html", session: session)
  end

  def create(conn, %{"authentication_request" => attrs}) do
    session = Accounts.create_session_changeset(attrs)
    case session.valid? do
      false -> render(conn, "new.html", session: session)
      _ ->
        conn
        |> Yellr.Authentication.Accounts.perform_login(session)
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def destroy(conn, _) do
    conn
    |> Accounts.perform_logout()
    |> redirect(to: Routes.sessions_path(conn, :new))
  end

  def auth_error(conn, _, _) do
    redirect conn, to: Routes.sessions_path(conn, :new)
  end
end
