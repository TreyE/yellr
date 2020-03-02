defmodule Yellr.Command.UpdateProject do
  alias Yellr.Repo
  alias Yellr.Data.Project
  alias Yellr.Validators.CreateProjectRequest

  @spec get_editable_project(number | String.t) :: Ecto.Changeset.t(Yellr.Validators.CreateProjectRequest.t)
  def get_editable_project(id) do
    record = Repo.get!(Project, id)
    CreateProjectRequest.new(%{
      name: record.name,
      repository_url: record.repository_url
    })
  end

  def update_project_from_params(id, params) do
    cs = CreateProjectRequest.new(params)
    case cs.valid? do
      false -> {:error, cs}
      _ -> update_models(id, params)
    end
  end

  def update_models(id, params) do
    record = Repo.get!(Project, id)
    cs = Project.changeset(record, params)
    new_record = Repo.update!(cs)
    {:ok, new_record}
  end
end
