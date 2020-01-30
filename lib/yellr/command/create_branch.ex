defmodule Yellr.Command.CreateBranch do
  alias Yellr.Data.Branch
  alias Yellr.Repo
  alias DataTasks.CreateInitialBuildResult

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
    CreateInitialBuildResult.new(%{
      "branch_id" => branch_record.id,
      "initial_status" => initial_status
    })
    |> Oban.insert!()
  end
end
