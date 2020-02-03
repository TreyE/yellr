defmodule Yellr do
  @moduledoc """
  Root context for domain logic and data interaction.

  If your code lives somewhere that isn't in the domain logic, you go through
  this interface and it's functions.

  If later this interface becomes too noisy, we'll examine other context
  modules with limited interfaces, such as Yellr.Command.
  """

  alias Yellr.Queries
  alias Yellr.Validators
  alias Yellr.Command.CreateBranch
  alias Yellr.Command.DestroyBranch
  alias Yellr.Command.ToggleBranchMonitor
  alias Yellr.Command.ReportBuildResult

  alias YellrWeb.Channels.BranchUpdateChannel

  @spec monitored_branches_with_results() ::
    [Ecto.Schema.t(Yellr.Data.Branch)]
  def monitored_branches_with_results() do
    Queries.Branches.monitored_branches_with_results()
  end

  @spec project_list() ::
    [Ecto.Schema.t(Yellr.Data.Project)]
  def project_list() do
    Queries.Projects.project_list()
  end

  @spec project_by_id_with_branches(any()) ::
    Ecto.Schema.t(Yellr.Data.Project) | nil
  def project_by_id_with_branches(project_id) do
    Queries.Projects.project_by_id_with_branches(project_id)
  end

  @spec form_for_new_branch(any()) ::
    Ecto.Changeset.t(Validators.CreateBranchRequest.t)
  def form_for_new_branch(project_id) do
    Validators.CreateBranchRequest.form_for_new_branch(project_id)
  end

  @spec create_branch_from_params(map()) ::
  {:ok, Branch.t()} |  {:error, Ecto.Changeset.t(CreateBranchRequest.t())}
  def create_branch_from_params(params) do
    CreateBranch.create_branch_from_params(params)
  end

  def destroy_branch_by_id(branch_id) do
    DestroyBranch.destroy_branch_by_id(branch_id)
  end

  def toggle_monitor_by_id(branch_id, monitor_val) do
    ToggleBranchMonitor.toggle_monitor_by_id(branch_id, monitor_val)
  end

  def broadcast_branch_updates() do
    BranchUpdateChannel.broadcast_branches_updated()
  end

  def report_result_from_params(params) do
    ReportBuildResult.report_result_from_params(params)
  end
end
