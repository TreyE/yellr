defmodule YellrWeb.ViewModels.BuildResult do
  defstruct [:project, :branch, :timestamp, :passing, :contributors]

  def new(branch_with_associations) do
    contributor_list = get_contributor_list(branch_with_associations.current_result)
    %__MODULE__{
      project: branch_with_associations.project.name,
      branch: branch_with_associations.name,
      timestamp: branch_with_associations.current_result.inserted_at,
      passing: (branch_with_associations.current_result.status == "passing"),
      contributors: contributor_list
    }
  end

  defp get_contributor_list(build_result) do
    build_result.contributions
    |> Enum.reduce([], fn(contribution, acc) ->
      [contribution.author, contribution.committer|acc]
    end)
    |> Enum.uniq()
  end
end
