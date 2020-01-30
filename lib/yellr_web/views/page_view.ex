defmodule YellrWeb.PageView do
  use YellrWeb, :view

  def build_time(branch) do
    DateTime.truncate(branch.timestamp, :second)
  end

  def contributor_list(branch) do
    Enum.join(branch.contributors, ", ")
  end

  def branch_status_class(branch) do
    if branch.passing do
      "bg-success"
    else
      "bg-danger"
    end
  end

  def broken_builds(branches) do
    !Enum.all?(branches, &(&1.passing))
  end
end
