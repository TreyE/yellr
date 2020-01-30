defmodule Yellr.Command.ReportBuildResult do
  alias Yellr.Validators.ReportedBuildResult
  alias Yellr.Data.BuildResult
  alias Yellr.Repo

  import Ecto.Query

  def report_result_from_params(params) do
    changeset = ReportedBuildResult.new(params)
    case changeset.valid? do
      false -> {:error, changeset}
      _ -> process_reported_result(changeset)
    end
  end

  defp process_reported_result(changeset) do
    rbr = Ecto.Changeset.apply_changes(changeset)
    project = Repo.one(find_project_by_name(rbr.project))
    branch = Repo.one(find_branch_by_name_and_project_id(rbr.branch, project.id))
    build_new_result_and_queue_task(rbr, branch)
    {:ok, changeset}
  end

  defp find_project_by_name(p_name) do
    from p in Yellr.Data.Project,
      where: p.name == ^p_name
  end

  defp find_branch_by_name_and_project_id(branch_name, project_id) do
    from b in Yellr.Data.Branch,
      where: (b.name == ^branch_name) and (b.project_id == ^project_id)
  end

  defp build_new_result_and_queue_task(rbr, branch) do
    br_cs = BuildResult.changeset(
      %BuildResult{},
      %{
        status: rbr.status,
        sha: rbr.sha,
        branch_id: branch.id
      }
    )
    {:ok, br_record} = Repo.insert(br_cs)
    DataTasks.RetrieveResultCombinations.new(
      %{"build_result_id" => br_record.id}
    )
    |> Oban.insert!
  end
end
