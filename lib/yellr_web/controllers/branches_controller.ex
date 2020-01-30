defmodule YellrWeb.BranchesController do
  use YellrWeb, :controller

  def new(conn, %{"project_id" => project_id}) do
    branch = Yellr.form_for_new_branch(project_id)
    render(conn, "new.html", %{branch: branch})
  end

  def create(conn, %{"branch" => atts}) do
    result = Yellr.create_branch_from_params(atts)
    case result do
      {:error, cs} -> render(conn, "new.html", %{branch: cs})
      {:ok, record} -> redirect(conn, to: YellrWeb.Router.Helpers.projects_path(conn, :show, record.project_id))
    end
  end

  def delete(conn, %{"id" => branch_id}) do
    record = Yellr.destroy_branch_by_id(branch_id)
    redirect(conn, to: YellrWeb.Router.Helpers.projects_path(conn, :show, record.project_id))
  end

  def update(conn, %{"id" => branch_id, "monitor" => monitor_val}) do
    record = Yellr.toggle_monitor_by_id(branch_id, monitor_val)
    redirect(conn, to: YellrWeb.Router.Helpers.projects_path(conn, :show, record.project_id))
  end
end
