defmodule Yellr.Queries.MonitoredBranches do
  import Ecto.Query

  alias Yellr.Repo
  alias Yellr.Data.Branch
  alias Yellr.Data.BuildResult
  alias Yellr.Data.Contribution

  def monitored_branches_with_success_rate() do
    query = (
      from b in Branch,
      where: b.monitored == true,
      join: cr in BuildResult,
      on: cr.id == b.current_result_id,
      join: br in BuildResult,
      on: br.branch_id == b.id,
      preload: [:project, [current_result: [:contributions]]],
      group_by: [b.id],
      select: {
        b,
        sum(fragment("case ? when 'passing' then 1 else 0 end", br.status)),
        count(br.id, :distinct)
      }
    )
    Repo.all(query)
  end

  def previous_build_status_for(branch_id) do
    query = (
      from br in BuildResult,
      join: con in Contribution,
      on: br.id == con.build_result_id,
      where: br.branch_id == ^branch_id,
      order_by: [desc: br.inserted_at],
      group_by: [br.id],
      limit: 2
    )
    brs = Repo.all(query)
    case Enum.count(brs) > 1 do
      false -> nil
      _ -> Enum.at(brs, 1).status
    end
  end
end
