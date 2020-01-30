defmodule Yellr.Data.Contribution do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime_usec]

  import Ecto.Changeset

  alias Yellr.Data.Contribution
  alias Yellr.Data.BuildResult

  schema "contributions" do
    field :sha, :string
    field :committer, :string
    field :author, :string
    field :timestamp, :utc_datetime_usec

    belongs_to :build_result, BuildResult
    timestamps()
  end

  def changeset(%Contribution{} = rec, attrs) do
    rec
    |> cast(attrs, [:sha, :committer, :author, :timestamp, :build_result_id])
    |> validate_required([:sha, :committer, :author, :timestamp, :build_result_id])
    |> validate_length(:sha, min: 1, max: 512)
    |> validate_length(:author, min: 1, max: 512)
    |> validate_length(:committer, min: 1, max: 512)
  end
end
