defmodule Norte.Processes.Process do
  use Ecto.Schema
  import Ecto.Changeset
  alias Norte.Util

  schema "processes" do
    field :key, :string
    field :name, :string
    field :up_id, :id
    belongs_to(:client, Norte.Accounts.Client)

    timestamps()
  end

  @doc false
  def changeset(area, attrs) do
    area
    |> cast(attrs, [:key, :name, :client_id, :up_id])
    |> validate_required([:key, :name])
    |> Util.validate_key_format(:key)
    |> unique_constraint(:key)
  end

  def update_changeset(unit, attrs) do
    unit
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
