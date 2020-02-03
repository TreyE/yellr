defmodule YellrWeb.PageController do
  use YellrWeb, :controller

  alias YellrWeb.ViewModels.BuildResult

  def index(conn, _params) do
    branch_records = Yellr.monitored_branches_with_results()
    branches = Enum.map(branch_records, fn(branch) ->
      BuildResult.new(branch)
    end)
    render(conn, "index.html", %{branches: branches})
  end
end
