defmodule Yellr.Data.BuildResult do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime_usec]

  import Ecto.Changeset

  alias Yellr.Data.BuildResult
  alias Yellr.Data.Branch
  alias Yellr.Data.Contribution

  @type t :: %__MODULE__{

  }

  schema "build_results" do
    field :sha, :string
    field :status, :string, default: "passing"

    belongs_to :branch, Branch
    has_many :contributions, Contribution
    timestamps()
  end

  def changeset(%BuildResult{} = rec, attrs) do
    rec
    |> cast(attrs, [:sha, :status, :branch_id])
    |> validate_required([:sha, :branch_id])
    |> validate_length(:sha, min: 1, max: 512)
  end
end
