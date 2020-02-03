defmodule Yellr.Command.CreateBranch do
  alias Yellr.Data.Branch
  alias Yellr.Repo

  alias Yellr.Validators.CreateBranchRequest

  @spec create_branch_from_params(map()) ::
     {:ok, Branch.t()} |  {:error, Ecto.Changeset.t(CreateBranchRequest.t())}
  def create_branch_from_params(params) do
    cs = CreateBranchRequest.new(params)
    case cs.valid? do
      false -> {:error, cs}
      _ -> build_branch_models(cs)
    end
  end

  defp build_branch_models(changeset) do
    cbr = Ecto.Changeset.apply_changes(changeset)
    branch_record = create_branch_with_status(
      cbr.project_id,
      cbr.name,
      cbr.monitored,
      cbr.initial_status
    )
    {:ok, branch_record}
  end

  defp create_branch_with_status(
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
    branch_record
  end
end
