defmodule Yellr.Queries.Projects do
  import Ecto.Query

  alias Yellr.Repo

  def project_list() do
    query = (from p in Yellr.Data.Project)
    Repo.all(query)
  end

  def project_by_id_with_branches(project_id) do
    query = (
      from p in Yellr.Data.Project,
        where: p.id == ^project_id,
        preload: [:branches]
    )
    Repo.one(query)
  end
end
