defmodule Yellr.Validators.CreateProjectRequest do
  use Ecto.Schema

  import Ecto.Changeset

  alias Yellr.Validators.CreateProjectRequest

  schema "validators.create_project_request" do
    field :name, :string
    field :repository_url, :string
    field :initial_status, :string, default: "passing"
  end

  def new(attrs) do
    changeset(%CreateProjectRequest{}, attrs)
  end

  def changeset(%CreateProjectRequest{} = rec, attrs) do
    rec
    |> cast(attrs, [:name, :repository_url, :initial_status])
    |> validate_required([:name, :repository_url])
    |> validate_length(:name, min: 1, max: 512)
    |> validate_length(:repository_url, min: 1, max: 2048)
  end
end
