defmodule GitData.TeslaClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.github.com"
  plug Tesla.Middleware.Headers, [{"user-agent", "Yellr Client"}]
  plug Tesla.Middleware.DecodeJson

  def commit_info(client, sha) do
    result = get(
      "/repos/" <>
      client.owner_name <>
      "/" <>
      client.repository_name <>
      "/commits/" <>
      sha
      )
    IO.inspect(result)
    case result do
      {:ok, resp} ->
        {:ok, GitData.CommitInfo.from_github_commit_data(resp.body)}
      _ -> result
    end
  end

  def branch_head(client, branch_name) do
    result = get(
      "/repos/" <>
      client.owner_name <>
      "/" <>
      client.repository_name <>
      "/branches/" <>
      branch_name
      )
    case result do
      {:ok, resp} ->
        {:ok, GitData.CommitInfo.from_github_branch_data(resp.body)}
      _ -> result
    end
  end

  def commits_since(client, branch_name, from, until) do
    encoded_from = encode_iso8601(from)
    encoded_until = encode_iso8601(until)
    result = get(
      "/repos/" <>
      client.owner_name <>
      "/" <>
      client.repository_name <>
      "/commits",
      query: [sha: branch_name,
      since: encoded_from,
      until: encoded_until]
      )
    case result do
      {:ok, resp} ->
        {:ok, GitData.CommitInfo.from_github_commit_list(resp.body)}
      _ -> result
    end
  end

  defp encode_iso8601(datetime) do
    DateTime.to_iso8601(datetime)
  end
end
