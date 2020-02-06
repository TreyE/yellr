defmodule Yellr.Authentication.AuthenticationRequestTest do
  use ExUnit.Case, async: true

  alias Yellr.Authentication.AuthenticationRequest
  alias Yellr.Repo

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "is invalid without required fields" do
    changeset = AuthenticationRequest.changeset(%AuthenticationRequest{}, %{})
    false = changeset.valid?
    {"can't be blank", _} = Keyword.fetch!(changeset.errors, :username)
    {"can't be blank", _} = Keyword.fetch!(changeset.errors, :password)
  end

  test "is invalid for a user that doesn't exist" do
    build_user("test_username_for_authentication_request")
    changeset = AuthenticationRequest.changeset(
      %AuthenticationRequest{},
      %{
        username: "bogus",
        password: "whatever"
      }
    )
    false = changeset.valid?
    {"invalid credentials", _} = Keyword.fetch!(changeset.errors, :base)
  end

  test "is invalid for a user that exists but has an invalid password" do
    build_user("test_username_for_authentication_request")
    changeset = AuthenticationRequest.changeset(
      %AuthenticationRequest{},
      %{
        username: "test_username_for_authentication_request",
        password: "whatever"
      }
    )
    false = changeset.valid?
    {"invalid credentials", _} = Keyword.fetch!(changeset.errors, :base)
  end

  defp build_user(username) do
    changeset = Yellr.Data.Account.changeset(
      %Yellr.Data.Account{},
       %{
         username: username,
         password: "12345678",
         password_confirmation: "12345678"
       }
    )
    Repo.insert!(changeset)
  end
end
