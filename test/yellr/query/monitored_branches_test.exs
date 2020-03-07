defmodule Yellr.Queries.MonitoredBranchesTest do
  use ExUnit.Case, async: true

  alias Yellr.Queries.MonitoredBranches

  alias Yellr.Repo

  alias Yellr.Data.Branch
  alias Yellr.Data.BuildResult
  alias Yellr.Data.Project

  import Ecto.Query

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    proj = build_project()
    branch = build_branch(proj)
    build_results(branch)
    :ok
  end

  test "finds the right number of results" do
    results = MonitoredBranches.monitored_branches_with_success_rate()
    [{_, 1, 2}] = results
  end

  defp build_project() do
    cs = Project.changeset(
      %Project{},
      %{
        name: "Yellr.Queries.MonitoredBranchesTest_test_project",
        repository_url: "SOME_RANDOM_URL"
      }
    )
    Repo.insert!(cs)
  end

  defp build_branch(project) do
    cs = Branch.changeset(
       %Branch{},
       %{
         name: "master",
         monitored: true,
         project_id: project.id
       }
    )
    Repo.insert!(cs)
  end

  defp build_results(branch) do
    branch_id = branch.id
    first_cs = BuildResult.changeset(
      %BuildResult{},
      %{
        branch_id: branch_id,
        sha: "whatever1",
        status: "failing"
      }
    )
    Repo.insert!(first_cs)
    current_cs = BuildResult.changeset(
      %BuildResult{},
      %{
        branch_id: branch_id,
        sha: "whatever2",
        status: "passing"
      }
    )
    current_build_result = Repo.insert!(current_cs)
    query = (from b in Branch,
       where: b.id == ^branch_id
    )
    Repo.update_all(query, [set: [current_result_id: current_build_result.id]])
  end
end
