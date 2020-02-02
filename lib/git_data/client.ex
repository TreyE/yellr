defmodule GitData.Client do
  @moduledoc """
  A client instance for the GitHub API.
  """

  defstruct [:repository_name, :owner_name]

  @type t :: %__MODULE__{
    repository_name: String.t,
    owner_name: String.t
  }

  @doc """
  Build a client for a given repository.

  The repository can either be given as an already parsed URI, or as a string.
  """
  @spec new(binary | URI.t) :: t
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
