defmodule Yellr.Queries.Branches do
  import Ecto.Query

  alias Yellr.Repo

  def monitored_branches_with_results() do
    query = (
      from b in Yellr.Data.Branch,
      where: b.monitored == true,
      join: cr in Yellr.Data.BuildResult,
      on: cr.id == b.current_result_id,
      preload: [:project, [current_result: [:contributions]]]
    )
    Repo.all(query)
  end

  def find_branch_by_name_and_project_id(branch_name, project_id) do
    query = (from b in Yellr.Data.Branch,
      where: (b.name == ^branch_name) and (b.project_id == ^project_id))
    Repo.one(query)
  end

  def branch_by_name_and_project_name(branch_name, project_name) do
    query = (from b in Yellr.Data.Branch,
      join: p in Yellr.Data.Project,
      on: p.id == b.project_id,
      where: (b.name == ^branch_name) and (p.name == ^project_name))
    Repo.one(query)
  end
end
