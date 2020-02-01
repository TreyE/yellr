defmodule Yellr.Command.ReportBuildResult do
  alias Yellr.Validators.ReportedBuildResult
  alias Yellr.Data.BuildResult
  alias Yellr.Repo

  alias Yellr.Queries.Branches
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
    branch = Branches.find_branch_by_name_and_project_id(rbr.branch, project.id)
    br_record = build_new_result_and_queue_task(rbr, branch)
    {:ok, br_record}
  end

  defp find_project_by_name(p_name) do
    from p in Yellr.Data.Project,
      where: p.name == ^p_name
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
    DataTasks.enqueue_result_contribution_lookup(br_record.id)
    br_record
  end
end
