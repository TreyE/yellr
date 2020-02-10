defmodule Yellr.Data.Branch do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime_usec]

  import Ecto.Changeset

  alias Yellr.Data.Branch
  alias Yellr.Data.Project
  alias Yellr.Data.BuildResult

  @type t :: %__MODULE__{

  }

  schema "branches" do
    field :name, :string
    field :monitored, :boolean, default: false

    belongs_to :project, Project
    belongs_to :current_result, BuildResult

    timestamps()
  end

  def changeset(%Branch{} = rec, attrs) do
    rec
    |> cast(attrs, [:name, :monitored, :project_id, :current_result_id])
    |> validate_required([:name, :project_id])
    |> validate_length(:name, min: 1, max: 512)
  end
end
