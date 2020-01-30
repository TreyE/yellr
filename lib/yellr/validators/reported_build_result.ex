defmodule Yellr.Validators.ReportedBuildResult do
  use Ecto.Schema

  import Ecto.Changeset

  alias Yellr.Validators.ReportedBuildResult

  schema "validators.reported_build_result" do
    field :project, :string
    field :branch, :string
    field :sha, :string
    field :status, :string, default: "passing"
  end

  def new(attrs) do
    changeset(%ReportedBuildResult{}, attrs)
  end

  def changeset(%ReportedBuildResult{} = rec, attrs) do
    rec
    |> cast(attrs, [:project, :branch, :sha, :status])
    |> validate_length(:project, min: 1, max: 512)
    |> validate_length(:branch, min: 1, max: 512)
    |> validate_length(:sha, min: 1, max: 512)
  end
end
