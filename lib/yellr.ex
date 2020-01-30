defmodule Yellr do
  @moduledoc """
  Yellr keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
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
end
