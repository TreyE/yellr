defmodule Yellr.Data.Account do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime_usec]

  schema "accounts" do
    field :username, :string
    field :encrypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  def new() do
    %Yellr.Data.Account{}
    |> cast(%{}, [])
  end

  def changeset(%Yellr.Data.Account{} = account, attrs) do
    account
    |> cast(attrs, [:username, :password, :password_confirmation])
    |> validate_required(:username)
    |> validate_required(:password)
    |> validate_required(:password_confirmation)
    |> validate_length(:username, min: 5, max: 255)
    |> validate_length(:password, min: 8, max: 255)
    |> validate_length(:password_confirmation, min: 8, max: 255)
    |> validate_confirmation(:password)
    |> unique_constraint(:username, name: :unique_username)
    |> unsafe_validate_unique([:username], Yellr.Repo)
    |> downcase_username()
    |> encrypt_password()
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)
    if password do
      encrypted_password = Pbkdf2.hash_pwd_salt(password)
      put_change(changeset, :encrypted_password, encrypted_password)
    else
      changeset
    end
  end

  defp downcase_username(changeset) do
    update_change(changeset, :username, &String.downcase/1)
  end
end
