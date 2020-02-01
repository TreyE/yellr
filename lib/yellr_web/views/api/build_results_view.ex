defmodule YellrWeb.Api.BuildResultsView do
  use YellrWeb, :view

  def render("error.json", %{changeset: changeset}) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
