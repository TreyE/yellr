defmodule YellrWeb.ViewModels.BuildResult do
  defstruct [
    :project,
    :branch,
    :timestamp,
    :passing,
    :contributors,
    :success_rate,
    :branch_id
  ]

  @type t :: %__MODULE__{
    project: String.t,
    branch: String.t,
    timestamp: DateTime.t,
    passing: boolean,
    contributors: String.t,
    success_rate: number,
    branch_id: any
  }
  def new({branch_with_associations, passed, total}) do
    success_rate = calculate_success_rate(passed, total)
    contributor_list = get_contributor_list(branch_with_associations.current_result)
    %__MODULE__{
      project: branch_with_associations.project.name,
      branch: branch_with_associations.name,
      timestamp: branch_with_associations.current_result.inserted_at,
      passing: (branch_with_associations.current_result.status == "passing"),
      contributors: contributor_list,
      success_rate: success_rate,
      branch_id: branch_with_associations.id
    }
  end

  def previous_build_was_failure?(record) do
    previous_status = Yellr.previous_build_status_for(record.branch_id)
    case previous_status do
      nil -> false
      a -> !(a == "passing")
    end
  end

  def calculate_success_rate(passed, total) do
    round(
      (passed * 100.0)/(total * 1.0)
    )
  end

  defp get_contributor_list(build_result) do
    build_result.contributions
    |> Enum.reduce([], fn(contribution, acc) ->
      [contribution.author, contribution.committer|acc]
    end)
    |> Enum.uniq()
  end
end
