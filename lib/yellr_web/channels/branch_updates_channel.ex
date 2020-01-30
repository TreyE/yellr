defmodule YellrWeb.Channels.BranchUpdateChannel do
  use Phoenix.Channel

  def join("branch_updates", _params, socket) do
    {:ok, socket}
  end

  def broadcast_branches_updated() do
    YellrWeb.Endpoint.broadcast(
      "branch_updates",
      "branches_updated",
      %{}
    )
  end
end
