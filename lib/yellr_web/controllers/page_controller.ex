defmodule YellrWeb.PageController do
  use YellrWeb, :controller

  def index(conn, _params) do
    branch_records = Yellr.Queries.Branches.monitored_branches_with_results()
    branches = Enum.map(branch_records, fn(branch) ->
      YellrWeb.ViewModels.BuildResult.new(branch)
    end)
    render(conn, "index.html", %{branches: branches})
  end
end
