defmodule YellrWeb.PageView do
  use YellrWeb, :view

  def build_time(branch) do
    branch.timestamp
    |> shift_to_eastern_time_zone()
    |> DateTime.truncate(:second)
    |> format_build_time()
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

  def branch_rate_class(branch) do
    if branch.passing do
      "badge-success"
    else
      "badge-danger"
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

  def have_builds?(build_results) do
    Enum.any?(build_results)
  end

  def most_recent_was_successful?(build_results) do
    most_recent_first = Enum.sort_by(
      build_results,
      &(&1),
      fn(a,b) ->
        order_date_times(b.timestamp, a.timestamp)
      end
    )
    most_recent_build = List.first(most_recent_first)
    most_recent_build.passing
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

  defp format_build_time(bt) do
    # year = bt.year
    month = bt.month
    day = bt.day
    hour = bt.hour
    minute = bt.minute
    month_s = String.pad_leading(to_string(month), 2, "0")
    day_s = String.pad_leading(to_string(day), 2, "0")
    min_s = String.pad_leading(to_string(minute), 2, "0")
    m_ind = case hour < 12 do
      false -> "P"
      _ -> "A"
    end
    h_num = case hour > 12 do
      false -> hour
      _ -> hour - 12
    end
    hour_s = String.pad_leading(to_string(h_num), 2, "0")
    "#{month_s}/#{day_s} #{hour_s}:#{min_s}#{m_ind}"
  end

  defp shift_to_eastern_time_zone(dt) do
    tz_info = Timex.Timezone.get("America/New_York", dt)
    DateTime.add(dt, tz_info.offset_utc + tz_info.offset_std, :second)
  end
end
