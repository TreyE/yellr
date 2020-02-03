defmodule GitData do
  @moduledoc """
  Grab data from git repositories.
  """

  @type commit_sha :: String.t()
  @type branch :: String.t()

  alias GitData.TeslaClient
  alias GitData.Client

  @spec commits_between(Client.t(), branch, DateTime.t(), DateTime.t()) ::
          {:ok, [GitData.CommitInfo.t()]} | {:error, any}
  def commits_between(client, branch, from, until) do
    TeslaClient.commits_since(client, branch, from, until)
  end

  @spec client_for(String.t()) :: Client.t()
  def client_for(respository_uri) do
    Client.new(respository_uri)
  end

  @spec commit_information(Client.t(), commit_sha) ::
          {:ok, GitData.CommitInfo.t()} | {:error, any}
  def commit_information(client, commit) do
    TeslaClient.commit_info(client, commit)
  end

  @spec branch_head(Client.t(), branch) :: {:ok, GitData.CommitInfo.t()} | {:error, any}
  def branch_head(client, branch_name) do
    TeslaClient.branch_head(client, branch_name)
  end
end
