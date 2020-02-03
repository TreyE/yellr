defmodule  GitData.ClientTest do
  use ExUnit.Case, async: true

  test "creates new client given a parsable URL" do
     client = GitData.Client.new("https://github.com/TreyE/yellr.git")
     "TreyE" = client.owner_name
     "yellr" = client.repository_name
  end

  test "creates new client given an already parsed URL" do
    uri = URI.parse("https://github.com/TreyE/yellr.git")
    client = GitData.Client.new(uri)
    "TreyE" = client.owner_name
    "yellr" = client.repository_name
  end
end
