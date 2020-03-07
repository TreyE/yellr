defmodule Yellr.Queries.MonitoredBranches do
  import Ecto.Query

  alias Yellr.Repo
  alias Yellr.Data.Branch
  alias Yellr.Data.BuildResult

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
end
