defmodule GitData.TeslaClient do
  @moduledoc false

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.github.com"
  plug Tesla.Middleware.Headers, [{"user-agent", "Yellr Client"}]
  plug GitData.GithubPat
  plug Tesla.Middleware.DecodeJson

  alias GitData.ApiUrls
  alias GitData.CommitInfo

  def commit_info(client, sha) do
    result = get(
      ApiUrls.commit_info_url(client, sha)
    )
    case result do
      {:ok, resp} ->
        {:ok, CommitInfo.from_github_commit_data(resp.body)}
      _ -> result
    end
  end

  def branch_head(client, branch_name) do
    result = get(
      ApiUrls.branch_info_url(client, branch_name)
    )
    case result do
      {:ok, resp} ->
        {:ok, CommitInfo.from_github_branch_data(resp.body)}
      _ -> result
    end
  end

  def commits_since(client, branch_name, from, until) do
    result = get(
      ApiUrls.commit_search_url(client),
      query: ApiUrls.commit_search_params(branch_name, from, until)
    )
    case result do
      {:ok, resp} ->
        {:ok, CommitInfo.from_github_commit_list(resp.body)}
      _ -> result
    end
  end
end
