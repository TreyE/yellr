defmodule Yellr.Authentication.Accounts do
  alias Yellr.Repo

  alias Yellr.Authentication.AuthenticationRequest

  def account_by_id(id) do
    Repo.get!(Yellr.Data.Account, id)
  end

  def perform_login(conn, cs) do
    user = AuthenticationRequest.authorized_user(cs)
    Yellr.Authentication.Guardian.Plug.sign_in(conn, user)
  end

  def perform_logout(conn) do
    Yellr.Authentication.Guardian.Plug.sign_out(conn)
  end

  def new_session_changeset() do
    AuthenticationRequest.new()
  end

  def create_session_changeset(attrs) do
    AuthenticationRequest.changeset(
      %AuthenticationRequest{},
      attrs
    )
  end
end
