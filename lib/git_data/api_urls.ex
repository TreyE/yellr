defmodule GitData.ApiUrls do
  @moduledoc """
  Build URLs for GitHub API endpoints.
  """

  @spec commit_info_url(GitData.Client.t, String.t) :: String.t
  def commit_info_url(client, sha) do
    "/repos/" <>
    client.owner_name <>
    "/" <>
    client.repository_name <>
    "/commits/" <>
    sha
  end

  @spec branch_info_url(GitData.Client.t, String.t) :: String.t
  def branch_info_url(client, branch_name) do
    "/repos/" <>
    client.owner_name <>
    "/" <>
    client.repository_name <>
    "/branches/" <>
    branch_name
  end

  @spec commit_search_url(GitData.Client.t) :: String.t
  def commit_search_url(client) do
    "/repos/" <>
    client.owner_name <>
    "/" <>
    client.repository_name <>
    "/commits"
  end

  @spec commit_search_params(String.t, DateTime.t, DateTime.t) :: Keyword.t
  def commit_search_params(branch_name, from, until) do
    encoded_from = encode_iso8601(from)
    encoded_until = encode_iso8601(until)
    [
      sha: branch_name,
      since: encoded_from,
      until: encoded_until
    ]
  end

  defp encode_iso8601(datetime) do
    DateTime.to_iso8601(datetime)
  end
end
