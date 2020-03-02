defmodule YellrWeb.PageView do
  use YellrWeb, :view

  def build_time(branch) do
    DateTime.truncate(branch.timestamp, :second)
  end

  def contributor_list(branch) do
    Enum.join(branch.contributors, ", ")
  end

  def branch_status_class(branch) do
    if branch.passing do
      "bg-success"
    else
      "bg-danger"
    end
  end

  def broken_builds(branches) do
    !Enum.all?(branches, &(&1.passing))
  end

  @spec sort_build_results([YellrWeb.ViewModels.BuildResult.t], master: boolean) :: [YellrWeb.ViewModels.BuildResult.t]
  def sort_build_results(build_results, master: true) do
    build_results
    |> Enum.filter(fn(br) -> br.branch == "master" end)
    |> sort_build_results_by_date()
  end

  def sort_build_results(build_results, master: false) do
    build_results
    |> Enum.reject(fn(br) -> br.branch == "master" end)
    |> sort_build_results_by_date()
  end

  defp sort_build_results_by_date(build_results) do
    Enum.sort_by(
    build_results,
    &(&1),
    fn(a, b) ->
      case {a.branch, b.branch} do
        {"master", "master"} -> order_date_times(b.timestamp, a.timestamp)
        {"master", _} -> true
        {_, "master"} -> false
        _ -> order_date_times(b.timestamp, a.timestamp)
      end
    end
    )
  end

  defp order_date_times(a, b) do
    case DateTime.compare(a, b) do
      :lt -> true
      :eq -> true
      :gt -> false
    end
  end
end
