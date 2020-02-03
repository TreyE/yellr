defmodule DataTasks do
  @moduledoc """
  Queueing of async data tasks.

  This is the context interface for the creation and enqueueing of all
  asynchronous data tasks.  Currently, we run our tasks using Oban.
  """

  alias DataTasks.RetrieveResultContributions
  alias DataTasks.CreateInitialBuildResult

  @doc """
  Enqueue the lookup of contributions for a build result.
  """
  def enqueue_result_contribution_lookup(build_result_id) do
    RetrieveResultContributions.new(
      %{"build_result_id" => build_result_id}
    )
    |> Oban.insert!
  end

  @doc """
  Enqueue the lookup of contributions for the first build result in a new branch.
  """
  def enqueue_create_initial_build_result(branch_id, initial_status) do
    CreateInitialBuildResult.new(%{
      "branch_id" => branch_id,
      "initial_status" => initial_status
    })
    |> Oban.insert!()
  end
end
