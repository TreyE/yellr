defmodule Yellr.Command.CreateBranch do
  alias Yellr.Data.Branch
  alias Yellr.Repo

  def create_branch_with_status(
    project_id,
    branch_name,
    is_monitored,
    initial_status
    ) do
    b_cs = Branch.changeset(
      %Branch{},
      %{
        project_id: project_id,
        name: branch_name,
        monitored: is_monitored
      }
    )
    {:ok, branch_record} = Repo.insert(b_cs)
    DataTasks.enqueue_create_initial_build_result(branch_record.id, initial_status)
  end
end
