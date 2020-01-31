defmodule Yellr.Repo.Migrations.CreateInitialTables do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, size: 512, null: false
      add :repository_url, :string, size: 2048, null: false

      timestamps([type: :utc_datetime_usec])
    end

    create table(:branches) do
      add :name, :string, size: 512, null: false
      add :monitored, :boolean, default: false

      add :project_id, references(:projects), null: false

      timestamps([type: :utc_datetime_usec])
    end

    create index(:branches, [:project_id])
    create index(:branches, [:monitored])

    create table(:build_results) do
      add :sha, :string, size: 512, null: false
      add :status, :string, size: 64, null: false, default: "passing"
      add :branch_id, references(:branches), null: false

      timestamps([type: :utc_datetime_usec])
    end

    create index(:build_results, [:branch_id])

    create table(:contributions) do
      add :committer, :string, size: 512, null: false
      add :author, :string, size: 512, null: false
      add :sha, :string, size: 512, null: false
      add :timestamp, :utc_datetime_usec, null: false
      add :build_result_id, references(:build_results), null: false

      timestamps([type: :utc_datetime_usec])
    end

    alter table(:branches) do
      add :current_result_id, references(:build_results), null: true
    end

    create index(:branches, [:current_result_id])

    create table("accounts") do
      add :username, :string, size: 255, null: false
      add :encrypted_password, :string, size: 2048, null: false

      timestamps()
    end

    create unique_index(:accounts, [:username], name: :unique_username)
  end
end
