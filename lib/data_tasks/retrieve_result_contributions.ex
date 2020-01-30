defmodule DataTasks.RetrieveResultContributions do
  use Oban.Worker, queue: :git

  alias Yellr.Repo
  alias Yellr.Data.Branch
  alias Yellr.Data.BuildResult
  alias Yellr.Data.Contribution

  import Ecto.Query

  @impl Oban.Worker
  def perform(%{"build_result_id" => build_result_id}, _job) do
    build_result = Repo.one(query_build_result_by_id(build_result_id))
    client = GitData.client_for(build_result.branch.project.repository_url)
    {:ok, commit} = GitData.commit_information(client, build_result.sha)
    build_contribution_for(build_result, commit)
    first_commit = get_last_contribution_for(build_result.branch.current_result_id)
    {:ok, commits} = GitData.commits_between(client, build_result.branch.name, first_commit.timestamp, commit.timestamp)
    Enum.each(commits, fn(c) ->
      build_contribution_for(build_result, c)
    end)
    set_as_current_build_result(build_result)
  end

  defp query_build_result_by_id(br_id) do
    from br in BuildResult,
       where: br.id == ^br_id,
       preload: [branch: [:project]]
  end

  defp build_contribution_for(build_result, commit) do
    cont = Contribution.changeset(
      %Contribution{},
      %{
        build_result_id: build_result.id,
        sha: commit.sha,
        timestamp: commit.timestamp,
        committer: commit.committer,
        author: commit.author
      }
    )
    Repo.insert!(cont)
  end

  defp get_last_contribution_for(current_result_id) do
    query = (from c in Contribution,
       where: c.build_result_id ==  ^current_result_id,
       order_by: [desc: c.timestamp],
       limit: 1
    )
    Repo.one!(query)
  end

  defp set_as_current_build_result(build_result) do
    branch_id = build_result.branch_id
    query = (from b in Branch,
       where: b.id == ^branch_id
    )
    Repo.update_all(query, [set: [current_result_id: build_result.id]])
  end
end
