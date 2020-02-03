defmodule Yellr.Command.ToggleBranchMonitor do
  alias Yellr.Data.Branch
  alias Yellr.Repo

  @spec toggle_monitor_by_id(any, any) ::
    Branch.t() | no_return
  def toggle_monitor_by_id(branch_id, monitor_val) do
    record = Repo.get!(Branch, branch_id)
    cs = Branch.changeset(
        record,
        %{
          monitored: monitor_val
        }
    )
    Repo.update!(cs)
    Yellr.broadcast_branch_updates()
    record
  end
end
