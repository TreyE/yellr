defmodule Yellr.Command.CreateProject do
  alias Yellr.Validators.CreateProjectRequest
  alias Yellr.Data.Project
  alias Yellr.Data.Branch
  alias Yellr.Repo
  alias DataTasks.CreateInitialBuildResult

  def create_project_from_params(params) do
    cs = CreateProjectRequest.new(params)
    case cs.valid? do
      false -> {:error, cs}
      _ -> create_models_and_queue_events(cs)
    end
  end

  defp create_models_and_queue_events(changeset) do
    create_project_request = Ecto.Changeset.apply_changes(changeset)
    p_cs = Project.changeset(
      %Project{},
      %{
        name: create_project_request.name,
        repository_url: create_project_request.repository_url
      }
    )
    {:ok, project_record} = Repo.insert(p_cs)
    b_cs = Branch.changeset(
      %Branch{},
      %{
        project_id: project_record.id,
        name: "master"
      }
    )
    {:ok, branch_record} = Repo.insert(b_cs)
    CreateInitialBuildResult.new(%{
      "branch_id" => branch_record.id,
      "initial_status" => create_project_request.initial_status
    })
    |> Oban.insert!()
    {:ok, changeset}
  end
end
