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
    [{Yellr.Data.Branch.t, number, number}]
  def monitored_branches_with_results() do
    Queries.MonitoredBranches.monitored_branches_with_success_rate()
  end

  @spec project_list() ::
    [Yellr.Data.Project.t]
  def project_list() do
    Queries.Projects.project_list()
  end

  @spec project_by_id_with_branches(any()) ::
    Yellr.Data.Project.t | nil
  def project_by_id_with_branches(project_id) do
    Queries.Projects.project_by_id_with_branches(project_id)
  end

  @spec form_for_new_branch(any()) ::
    Ecto.Changeset.t(Validators.CreateBranchRequest.t)
  def form_for_new_branch(project_id) do
    Validators.CreateBranchRequest.form_for_new_branch(project_id)
  end

  @spec create_branch_from_params(map()) ::
  {:ok, Yellr.Data.Branch.t()} |  {:error, Ecto.Changeset.t(Yellr.Validators.CreateBranchRequest.t())}
  def create_branch_from_params(params) do
    CreateBranch.create_branch_from_params(params)
  end

  @spec destroy_branch_by_id(any()) ::
    Yellr.Data.Branch.t() | no_return
  def destroy_branch_by_id(branch_id) do
    DestroyBranch.destroy_branch_by_id(branch_id)
  end

  @spec toggle_monitor_by_id(any, any) ::
    Yellr.Data.Branch.t() | no_return
  def toggle_monitor_by_id(branch_id, monitor_val) do
    ToggleBranchMonitor.toggle_monitor_by_id(branch_id, monitor_val)
  end

  @spec broadcast_branch_updates() :: :ok | {:error, any}
  def broadcast_branch_updates() do
    BranchUpdateChannel.broadcast_branches_updated()
  end

  @spec report_result_from_params(map()) ::
    {:ok, Yellr.Data.BuildResult.t} | {:error, Ecto.Changeset.t(Yellr.Validators.ReportedBuildResult.t)}
  def report_result_from_params(params) do
    ReportBuildResult.report_result_from_params(params)
  end

  def new_project_creation_request() do
    Yellr.Validators.CreateProjectRequest.blank()
  end

  def create_project_from_params(params) do
    Yellr.Command.CreateProject.create_project_from_params(params)
  end

  @spec get_editable_project(number | String.t) :: Ecto.Changeset.t(Yellr.Validators.CreateProjectRequest.t)
  def get_editable_project(id) do
    Yellr.Command.UpdateProject.get_editable_project(id)
  end

  def update_project_from_params(id, params) do
    Yellr.Command.UpdateProject.update_project_from_params(id, params)
  end
end
