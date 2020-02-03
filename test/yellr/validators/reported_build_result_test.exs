defmodule Yellr.Validators.ReportedBuildResultTest do
  use ExUnit.Case, async: true

  alias Yellr.Validators.ReportedBuildResult
  alias Yellr.Repo

  @project_name "Yellr.Validators.ReportedBuildResultTest_test_proj"
  @branch_name "Yellr.Validators.ReportedBuildResultTest_test_branch"

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "is invalid without required fields" do
    changeset = ReportedBuildResult.new(%{})
    false = changeset.valid?
    {"can't be blank", _} = Keyword.fetch!(changeset.errors, :project)
    {"can't be blank", _} = Keyword.fetch!(changeset.errors, :branch)
    {"can't be blank", _} = Keyword.fetch!(changeset.errors, :sha)
  end

  test "has a default status of passing" do
    changeset = ReportedBuildResult.new(%{})
    record = Ecto.Changeset.apply_changes(changeset)
    "passing" = record.status
  end

  test "is invalid with a project that doesn't exist" do
    project = build_project(@project_name)
    branch = build_branch(project, @branch_name)
    changeset = ReportedBuildResult.new(%{
      project: "no such project",
      branch: branch.name
    })
    false = changeset.valid?
    {"does not exist", _} = Keyword.fetch!(changeset.errors, :branch)
  end

  test "is invalid with a branch that doesn't exist for the project" do
    project = build_project(@project_name)
    build_branch(project, @branch_name)
    changeset = ReportedBuildResult.new(%{
      branch: "no such branch",
      project: project.name
    })
    false = changeset.valid?
    {"does not exist", _} = Keyword.fetch!(changeset.errors, :branch)
  end

  test "is valid with an existing branch" do
    project = build_project(@project_name)
    branch = build_branch(project, @branch_name)
    changeset = ReportedBuildResult.new(%{
      branch: branch.name,
      project: project.name,
      sha: "some sha whatever"
    })
    true = changeset.valid?
  end

  defp build_project(p_name) do
    project_cs = Yellr.Data.Project.changeset(
      %Yellr.Data.Project{},
      %{
        name: p_name,
        repository_url: "whatever"
      }
    )
    Repo.insert!(project_cs)
  end

  defp build_branch(project, b_name) do
    branch_cs = Yellr.Data.Branch.changeset(
      %Yellr.Data.Branch{},
      %{
        name: b_name,
        project_id: project.id
      }
    )
    Repo.insert!(branch_cs)
  end
end
