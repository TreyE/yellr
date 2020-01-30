defmodule Yellr do
  @moduledoc """
  Yellr keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def monitored_branches_with_results() do
    Yellr.Queries.Branches.monitored_branches_with_results()
  end
end
