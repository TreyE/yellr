defmodule YellrWeb.ProjectsView do
  use YellrWeb, :view

  @spec sort_branches_for_display([Yellr.Data.Branch]) :: [Yellr.Data.Branch]
  def sort_branches_for_display(branches) do
    Enum.sort_by(branches, fn(b) -> b.name end)
  end
end
