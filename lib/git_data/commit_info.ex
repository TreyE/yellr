defmodule GitData.CommitInfo do
  @moduledoc """
  Represents info about a specific commit.

  Builds this data from a GitHub json payload.
  """

  defstruct [:sha, :committer, :author, :timestamp]

  @type t :: %__MODULE__{
    sha: String.t,
    committer: String.t,
    author: String.t,
    timestamp: DateTime.t
  }

  @doc false
  def from_github_branch_data(json_hash) do
    commit_hash = Map.get(json_hash, "commit", %{})
    from_github_commit_data(commit_hash)
  end

  @doc false
  def from_github_commit_list(json_array) do
    Enum.map(json_array, fn(item)  ->
      from_github_commit_data(item)
    end)
  end

  @doc false
  def from_github_commit_data(commit_hash) do
    commit_data = Map.get(commit_hash, "commit", %{})
    sha = Map.fetch!(commit_hash, "sha")
    author = Map.fetch!(commit_data, "author")
    author_name = Map.fetch!(author, "name")
    committer = Map.fetch!(commit_data, "committer")
    committer_name = Map.fetch!(committer, "name")
    date_string = Map.fetch!(committer, "date")
    {:ok, date, offset} = DateTime.from_iso8601(date_string)
    timestamp = DateTime.add(date, offset, :second)
    %__MODULE__{
      sha: sha,
      author: author_name,
      committer: committer_name,
      timestamp: timestamp
    }
  end
end
