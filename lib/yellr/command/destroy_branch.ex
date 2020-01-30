defmodule Yellr.Command.DestroyBranch do
  alias Yellr.Data.Branch
  alias Yellr.Data.BuildResult
  alias Yellr.Data.Contribution
  alias Yellr.Repo

  import Ecto.Query
  def destroy_branch_by_id(branch_id) do
    record = Repo.get!(Branch, branch_id)
    Repo.transaction(fn() ->
      unset_current_result(branch_id)
      destroy_contributions(branch_id)
      destroy_build_results(branch_id)
      Repo.delete!(record)
    end)
    Yellr.broadcast_branch_updates()
    record
  end

  defp destroy_contributions(branch_id) do
    query = (
      from c in Contribution,
      join: br in BuildResult,
      on: br.id == c.build_result_id,
      join: b in Branch,
      on: b.id == br.branch_id,
      where: b.id ==  ^branch_id
    )
    Repo.delete_all(query)
  end

  defp destroy_build_results(branch_id) do
    query = (
      from br in BuildResult,
      where: br.branch_id ==  ^branch_id
    )
    Repo.delete_all(query)
  end

  defp unset_current_result(branch_id) do
    query = (
      from b in Branch,
      where: b.id ==  ^branch_id
    )
    Repo.update_all(query, [set: [current_result_id: nil]])
  end
end
