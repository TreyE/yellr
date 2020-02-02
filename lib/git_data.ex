defmodule GitData do
  @moduledoc """
  Grab data from git repositories.
  """

  @type commit_sha :: String.t
  @type branch :: String.t

  @spec commits_between(GitData.Client.t, branch, DateTime.t, DateTime.t) :: {:ok, [GitData.CommitInfo.t]}  | {:error, any}
  def commits_between(client, branch, from, until) do
    GitData.TeslaClient.commits_since(client, branch, from, until)
  end

  @spec client_for(String.t) :: GitData.Client.t
  def client_for(respository_uri) do
    GitData.Client.new(respository_uri)
  end

  @spec commit_information(GitData.Client.t, commit_sha) :: {:ok, GitData.CommitInfo.t}  | {:error, any}
  def commit_information(client, commit) do
    GitData.TeslaClient.commit_info(client, commit)
  end

  @spec branch_head(GitData.Client.t, branch) :: {:ok, GitData.CommitInfo.t}  | {:error, any}
  def branch_head(client, branch_name) do
    GitData.TeslaClient.branch_head(client, branch_name)
  end
end
