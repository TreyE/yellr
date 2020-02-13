defmodule Yellr.Repo.Migrations.AddEnrollUiProject do
  use Ecto.Migration

  def change do
    Yellr.Command.CreateProject.create_project_from_params(%{
      "name" => "enroll-ui_dc",
      "repository_url" => "https://github.com/dchbx/enroll-ui.git"
    })
  end
end
