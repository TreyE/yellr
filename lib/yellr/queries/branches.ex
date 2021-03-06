defmodule Yellr.Queries.Branches do
  import Ecto.Query

  alias Yellr.Repo
  alias Yellr.Data.Branch
  alias Yellr.Data.Project

  def find_branch_by_name_and_project_id(branch_name, project_id) do
    query = (from b in Branch,
      where: (b.name == ^branch_name) and (b.project_id == ^project_id))
    Repo.one(query)
  end

  def branch_by_name_and_project_name(branch_name, project_name) do
    query = (from b in Branch,
      join: p in Project,
      on: p.id == b.project_id,
      where: (b.name == ^branch_name) and (p.name == ^project_name))
    Repo.one(query)
  end
end
