defmodule Yellr.Repo.Migrations.CreateQuotingToolProject do
  use Ecto.Migration

  def change do
    Yellr.Command.CreateProject.create_project_from_params(%{
      "name" => "quoting_tool-ma",
      "repository_url" => "https://github.com/health-connector/quoting_tool.git"
    })
  end
end
