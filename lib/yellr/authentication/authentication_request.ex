defmodule Yellr.Authentication.AuthenticationRequest do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "form_models.authentication_requests" do
    field :username, :string
    field :password, :string
  end

  def new() do
    %Yellr.Authentication.AuthenticationRequest{}
    |> cast(%{}, [])
  end

  def changeset(%Yellr.Authentication.AuthenticationRequest{} = account, attrs) do
    account
    |> cast(attrs, [:username, :password])
    |> validate_required(:username)
    |> validate_required(:password)
    |> downcase_username()
    |> check_username_and_password()
  end

  def authorized_user(changeset) do
    username = get_change(changeset, :username)
    query = (
      from a in Yellr.Data.Account,
      where: a.username == ^username
    )
    Yellr.Repo.one!(query)
  end

  defp downcase_username(changeset) do
    update_change(changeset, :username, &String.downcase/1)
  end

  defp check_username_and_password(changeset) do
    username = get_change(changeset, :username)
    password = get_change(changeset, :password)
    case {username,password} do
     {nil,_} -> changeset
     {_,nil} -> changeset
      _ -> validate_username_password(changeset, username, password)
    end
  end

  defp validate_username_password(changeset, username, password) do
    query = (
      from a in Yellr.Data.Account,
      where: a.username == ^username
    )
    found_user = Yellr.Repo.one(query)
    case found_user do
      nil -> add_invalid_credentials_error(changeset)
      _ -> validate_password(changeset, found_user, password)
    end
  end

  defp validate_password(changeset, found_user, password) do
    case Pbkdf2.verify_pass(password, found_user.encrypted_password) do
      false -> add_invalid_credentials_error(changeset)
      _ -> changeset
    end
  end

  defp add_invalid_credentials_error(changeset) do
    add_error(changeset, :base, "invalid credentials")
  end
end
