defmodule Norte.Base.Unit do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:key, :name])
    |> validate_required([:key, :name])
    |> unique_constraint(:key)
  end
end
