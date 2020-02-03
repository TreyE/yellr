defmodule  GitData.ApiUrlsTest do
  use ExUnit.Case, async: true

  @test_client %{
    owner_name: "TreyE",
    repository_name: "yellr"
  }

  test "creates the correct URL for getting commit information" do
    commit_sha = "SOME_SHA_GOES_HERE"
    url = GitData.ApiUrls.commit_info_url(@test_client, commit_sha)
    "/repos/TreyE/yellr/commits/SOME_SHA_GOES_HERE" = url
  end

  test "creates the correct URL for getting branch information" do
    branch_name = "SOME_BRANCH_NAME_GOES_HERE"
    url = GitData.ApiUrls.branch_info_url(@test_client, branch_name)
    "/repos/TreyE/yellr/branches/SOME_BRANCH_NAME_GOES_HERE" = url
  end

  test "creates the correct URL for searching commits" do
    url = GitData.ApiUrls.commit_search_url(@test_client)
    "/repos/TreyE/yellr/commits" = url
  end

  test "creates the correct params for searching commits" do
    branch_name = "SOME_BRANCH_NAME_GOES_HERE"
    from = ~U[2011-05-20 16:00:49Z]
    until = ~U[2011-05-25 13:12:50Z]
    params = GitData.ApiUrls.commit_search_params(branch_name, from, until)
    [
      sha: "SOME_BRANCH_NAME_GOES_HERE",
      since: "2011-05-20T16:00:49Z",
      until: "2011-05-25T13:12:50Z"
    ] = params
  end
end
