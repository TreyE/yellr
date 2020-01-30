defmodule YellrWeb.ProjectsController do
  use YellrWeb, :controller

  def index(conn, _params) do
    projects = Yellr.project_list()
    render(conn, "index.html", %{projects: projects})
  end

  def show(conn, %{"id" => project_id}) do
    project = Yellr.project_by_id_with_branches(project_id)
    render(conn, "show.html", %{project: project})
  end
end
