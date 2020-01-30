defmodule DataTasks.CreateInitialBuildResult do
  use Oban.Worker, queue: :git

  alias Yellr.Repo
  alias Yellr.Data.BuildResult
  alias Yellr.Data.Contribution

  import Ecto.Query

  @impl Oban.Worker
  def perform(%{"branch_id" => branch_id, "initial_status" => stat}, _job) do
    branch = Repo.one(find_branch_query(branch_id))
    client = GitData.client_for(branch.project.repository_url)
    {:ok, first_commit} = GitData.branch_head(client, branch.name)
    build_result = build_contribution_from(first_commit, branch_id, stat)
    Repo.update_all(find_branch_query(branch_id), set: [current_result_id: build_result.id])
  end

  defp find_branch_query(id) do
    (from b in Yellr.Data.Branch,
     where: b.id == ^id,
     preload: [:project]
    )
  end

  defp build_contribution_from(github_commit, branch_id, status) do
    brcs = BuildResult.changeset(
      %BuildResult{},
      %{
        branch_id: branch_id,
        status: status,
        sha: github_commit.sha
      }
    )
    {:ok, br_record} = Repo.insert(brcs)
    cont_cs = Contribution.changeset(
      %Contribution{},
      %{
        build_result_id: br_record.id,
        sha: github_commit.sha,
        committer: github_commit.committer,
        author: github_commit.author,
        timestamp: github_commit.timestamp
      }
    )
    {:ok, _} = Repo.insert(cont_cs)
    br_record
  end
end
