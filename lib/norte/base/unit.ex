defmodule Norte.Base.Unit do
  use Ecto.Schema
  import Ecto.Changeset
  alias Norte.Util

  schema "units" do
    field :key, :string
    field :name, :string
    field :up_id, :id
    field :client_id, :id

    timestamps()
  end

  @doc false
  def changeset(unit, attrs) do
    unit
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
