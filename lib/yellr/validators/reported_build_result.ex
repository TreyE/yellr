defmodule Yellr.Validators.ReportedBuildResult do
  use Ecto.Schema

  import Ecto.Changeset

  alias Yellr.Validators.ReportedBuildResult
  alias Yellr.Queries.Branches

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
    |> validate_required([:project, :branch, :sha])
    |> validate_length(:project, min: 1, max: 512)
    |> validate_length(:branch, min: 1, max: 512)
    |> validate_length(:sha, min: 1, max: 512)
    |> validate_branch_exists()
  end

  defp validate_branch_exists(changeset) do
    project_value = Ecto.Changeset.get_change(changeset, :project)
    branch_value = Ecto.Changeset.get_change(changeset, :branch)
    case {project_value, branch_value} do
      {nil, _} -> changeset
      {_, nil} -> changeset
      {"", _} -> changeset
      {_, ""} -> changeset
      _ -> check_branch_exists(changeset, project_value, branch_value)
    end
  end

  defp check_branch_exists(changeset, project_name, branch_name) do
    branch = Branches.branch_by_name_and_project_name(branch_name, project_name)
    case branch do
      nil -> Ecto.Changeset.add_error(changeset, :branch, "does not exist")
      _ -> changeset
    end
  end
end
