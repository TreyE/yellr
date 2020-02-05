defmodule Yellr.Command.CreateBranchTest do
  use ExUnit.Case, async: true

  alias Yellr.Command.CreateBranch
  alias Yellr.Repo

  @project_name "Yellr.Command.CreateBranchTest_test_proj"

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "fails with an invalid branch request" do
    {:error, _} = CreateBranch.create_branch_from_params(%{})
  end

  test "creates a new branch" do
    project = build_project(@project_name)
    project_id = project.id
    {:ok, new_branch} = CreateBranch.create_branch_from_params(
      %{
        "project_id" => to_string(project_id),
        "name" => "master",
        "initial_status" => "passing",
        "monitored" => false
      }
    )
    "master" = new_branch.name
    ^project_id = new_branch.project_id
    false = new_branch.monitored
  end

  test "notifies about the created branch" do
    YellrMocks.Commands.CreateBranchDataTaskMock.setup()
    YellrMocks.Commands.CreateBranchDataTaskMock.allow(
      :enqueue_create_initial_build_result,
      fn([_,"passing"]) -> true end,
      :ok
    )
    project = build_project(@project_name)
    project_id = project.id
    {:ok, new_branch} = CreateBranch.create_branch_from_params(
      %{
        "project_id" => to_string(project_id),
        "name" => "master",
        "initial_status" => "passing",
        "monitored" => false
      },
      YellrMocks.Commands.CreateBranchDataTaskMock
    )
    YellrMocks.Commands.CreateBranchDataTaskMock.expect(
      :enqueue_create_initial_build_result,
      [
        new_branch.id,
        "passing"
      ]
    )
    YellrMocks.Commands.CreateBranchDataTaskMock.verify()
    "master" = new_branch.name
    ^project_id = new_branch.project_id
    false = new_branch.monitored
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
end
