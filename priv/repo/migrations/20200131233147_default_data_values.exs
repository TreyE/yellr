defmodule Yellr.Repo.Migrations.DefaultDataValues do
  use Ecto.Migration

  def change do
    execute("""
    INSERT INTO accounts (username,encrypted_password,inserted_at,updated_at)
      VALUES (
        'developer',
        '$pbkdf2-sha512$160000$KhHzBzcUjgNvKfWcf4ezRg$7tMx0zsOeXD5U2RVmmvyRG9yFktFODmveERFLNkmLGRqoNjoxSTMOBfw77oyEM0HKXrtvTqWsmAlLzblI4XfCA',
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
      );
    """)
    Yellr.Command.CreateProject.create_project_from_params(%{
      "name" => "enroll_dc",
      "repository_url" => "https://github.com/dchbx/enroll.git"
    })
    Yellr.Command.CreateProject.create_project_from_params(%{
      "name" => "enroll_ma",
      "repository_url" => "https://github.com/health-connector/enroll.git"
    })
    Yellr.Command.CreateProject.create_project_from_params(%{
      "name" => "yellr",
      "repository_url" => "https://github.com/TreyE/yellr.git"
    })
  end
end
