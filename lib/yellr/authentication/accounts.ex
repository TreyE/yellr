defmodule Yellr.Authentication.Accounts do
  alias Yellr.Repo

  def account_by_id(id) do
    Repo.get!(Yellr.Data.Account, id)
  end

  def perform_login(conn, cs) do
    user = Yellr.Authentication.AuthenticationRequest.authorized_user(cs)
    Yellr.Authentication.Guardian.Plug.sign_in(conn, user)
  end

  def perform_logout(conn) do
    Yellr.Authentication.Guardian.Plug.sign_out(conn)
  end

  def store_account_changeset(cs) do
    Repo.insert!(cs)
  end

  def new_session_changeset() do
    Yellr.Authentication.AuthenticationRequest.new()
  end

  def create_session_changeset(attrs) do
    Yellr.Authentication.AuthenticationRequest.changeset(
      %Yellr.Authentication.AuthenticationRequest{},
      attrs
    )
  end
end
