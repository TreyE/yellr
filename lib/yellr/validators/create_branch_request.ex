defmodule Yellr.Validators.CreateBranchRequest do
  use Ecto.Schema

  import Ecto.Changeset

  alias Yellr.Validators.CreateBranchRequest

  @type t :: %__MODULE__{

  }

  schema "validators.create_branch_request" do
    field :name, :string
    field :project_id, :string
    field :initial_status, :string, default: "passing"
    field :monitored, :boolean, default: false
  end

  def form_for_new_branch(project_id) do
    %CreateBranchRequest{}
    |> cast(%{project_id: project_id}, [:project_id])
  end

  def new(attrs) do
    changeset(%CreateBranchRequest{}, attrs)
  end

  def changeset(%CreateBranchRequest{} = rec, attrs) do
    rec
    |> cast(attrs, [:name, :project_id, :initial_status, :monitored])
    |> validate_required([:name, :project_id])
    |> validate_length(:name, min: 1, max: 512)
  end
end
