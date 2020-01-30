defmodule Yellr.Data.Project do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime_usec]

  import Ecto.Changeset

  alias Yellr.Data.Project
  alias Yellr.Data.Branch

  schema "projects" do
    field :name, :string
    field :repository_url, :string

    has_many :branches, Branch
    timestamps()
  end

  def changeset(%Project{} = rec, attrs) do
    rec
    |> cast(attrs, [:name, :repository_url])
    |> validate_required([:name, :repository_url])
    |> validate_length(:name, min: 1, max: 512)
    |> validate_length(:repository_url, min: 1, max: 2048)
  end
end
