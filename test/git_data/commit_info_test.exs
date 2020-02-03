defmodule  GitData.CommitInfoTest do
  use ExUnit.Case, async: true

  test "builds info from a github commit structure" do
    github_commit_data = %{
      "commit" => %{
        "author" => %{
          "name" => "author_name",
          "date" => "2011-04-14T16:00:49Z"
        },
        "committer" => %{
          "name" => "committer_name",
          "date" => "2011-05-20T16:00:49Z"
        }
      },
      "sha" => "sha_value"
    }
    commit = GitData.CommitInfo.from_github_commit_data(github_commit_data)
    "sha_value" = commit.sha
    "author_name" = commit.author
    "committer_name" = commit.committer
    ~U[2011-05-20 16:00:49Z] = commit.timestamp
  end

end
