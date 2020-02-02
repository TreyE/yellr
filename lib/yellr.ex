defmodule Yellr do
  @moduledoc """
  Root context for domain logic and data interaction.

  If your code lives somewhere that isn't in the domain logic, you go through
  this interface and it's functions.

  If later this interface becomes too noisy, we'll examine other context
  modules with limited interfaces, such as Yellr.Command.
  """

  def monitored_branches_with_results() do
    Yellr.Queries.Branches.monitored_branches_with_results()
  end

  def project_list() do
    Yellr.Queries.Projects.project_list()
  end

  def project_by_id_with_branches(project_id) do
    Yellr.Queries.Projects.project_by_id_with_branches(project_id)
  end

  def form_for_new_branch(project_id) do
    Yellr.Validators.CreateBranchRequest.form_for_new_branch(project_id)
  end

  def create_branch_from_params(params) do
    Yellr.Command.CreateBranch.create_branch_from_params(params)
  end

  def destroy_branch_by_id(branch_id) do
    Yellr.Command.DestroyBranch.destroy_branch_by_id(branch_id)
  end

  def toggle_monitor_by_id(branch_id, monitor_val) do
    Yellr.Command.ToggleBranchMonitor.toggle_monitor_by_id(branch_id, monitor_val)
  end

  def broadcast_branch_updates() do
    YellrWeb.Channels.BranchUpdateChannel.broadcast_branches_updated()
  end

  def report_result_from_params(params) do
    Yellr.Command.ReportBuildResult.report_result_from_params(params)
  end
end
