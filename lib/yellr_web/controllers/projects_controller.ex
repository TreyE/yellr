defmodule YellrWeb.ProjectsController do
  use YellrWeb, :controller

  def new(conn, _params) do
    project = Yellr.new_project_creation_request()
    render(conn, "new.html", %{form: project})
  end

  def create(conn, %{"project" => params}) do
    result = Yellr.create_project_from_params(params)
    case result do
      {:error, cs} -> render(conn, "new.html", %{form: cs})
      {:ok, record} -> redirect(conn, to: YellrWeb.Router.Helpers.projects_path(conn, :show, record.id))
    end
  end

  def edit(conn, %{"id" => project_id}) do
    project = Yellr.get_editable_project(project_id)
    render(conn, "edit.html", %{form: project, id: project_id})
  end

  def update(conn, %{"project" => params, "id" => project_id}) do
    result = Yellr.update_project_from_params(project_id, params)
    case result do
      {:error, cs} -> render(conn, "edit.html", %{form: cs, id: project_id})
      {:ok, record} -> redirect(conn, to: YellrWeb.Router.Helpers.projects_path(conn, :show, record.id))
    end
  end

  def index(conn, _params) do
    projects = Yellr.project_list()
    render(conn, "index.html", %{projects: projects})
  end

  def show(conn, %{"id" => project_id}) do
    project = Yellr.project_by_id_with_branches(project_id)
    render(conn, "show.html", %{project: project})
  end
end
