defmodule GitData.Client do
  defstruct [:repository_name, :owner_name]

  def new(%URI{} = uri) do
    path = uri.path
    repo_name = Path.basename(path, ".git")
    owner_name = Enum.at(Path.split(path),1)
    %__MODULE__{
      repository_name: repo_name,
      owner_name: owner_name
    }
  end

  def new(repo_uri) do
    uri = URI.parse(repo_uri)
    path = uri.path
    repo_name = Path.basename(path, ".git")
    owner_name = Enum.at(Path.split(path),1)
    %__MODULE__{
      repository_name: repo_name,
      owner_name: owner_name
    }
  end
end
