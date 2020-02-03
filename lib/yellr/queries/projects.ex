defmodule Yellr.Queries.Projects do
  import Ecto.Query

  alias Yellr.Repo
  alias Yellr.Data.Project

  def project_list() do
    query = (from p in Project)
    Repo.all(query)
  end

  def project_by_id_with_branches(project_id) do
    query = (
      from p in Project,
        where: p.id == ^project_id,
        preload: [:branches]
    )
    Repo.one(query)
  end
end
