defmodule DataTasks do
  def enqueue_result_contribution_lookup(build_result_id) do
    DataTasks.RetrieveResultContributions.new(
      %{"build_result_id" => build_result_id}
    )
    |> Oban.insert!
  end

  def enqueue_create_initial_build_result(branch_id, initial_status) do
    DataTasks.CreateInitialBuildResult.new(%{
      "branch_id" => branch_id,
      "initial_status" => initial_status
    })
    |> Oban.insert!()
  end
end
