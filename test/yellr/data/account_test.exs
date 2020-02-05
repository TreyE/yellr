defmodule Yellr.Data.AccountTest do
  use ExUnit.Case, async: true

  alias Yellr.Data.Account

  test "is invalid without required fields" do
    changeset = Account.changeset(%Account{}, %{})
    false = changeset.valid?
    {"can't be blank", _} = Keyword.fetch!(changeset.errors, :username)
    {"can't be blank", _} = Keyword.fetch!(changeset.errors, :password)
    {"can't be blank", _} = Keyword.fetch!(changeset.errors, :password_confirmation)
  end

  test "is invalid with password and confirmation that don't match" do
    properties = %{
      password: "abcdefgh",
      password_confirmation: "12345678",
    }
    changeset = Account.changeset(%Account{}, properties)
    false = changeset.valid?
    {"does not match confirmation", _} = Keyword.fetch!(changeset.errors, :password_confirmation)
  end

  test "is valid password and confirmation that match" do
    properties = %{
      password: "abcdefgh",
      password_confirmation: "abcdefgh",
    }
    changeset = Account.changeset(%Account{}, properties)
    false = Keyword.has_key?(changeset.errors, :password)
    false = Keyword.has_key?(changeset.errors, :password_confirmation)
  end

  test "encrypts the password when password and confirmation match" do
    password = "12345678"
    properties = %{
      password: password,
      password_confirmation: password,
    }
    changeset = Account.changeset(%Account{}, properties)
    encrypted_password = Ecto.Changeset.get_change(changeset, :encrypted_password)
    true = Pbkdf2.verify_pass(password, encrypted_password)
  end
end
