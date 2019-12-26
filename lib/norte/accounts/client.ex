defmodule Norte.Accounts.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clients" do
    field :cid, :string
    field :code, :string
    field :name, :string
    field :status, :integer
    field :term, :utc_datetime
    field :val_unit, :decimal
    field :val_user, :decimal
    has_many(:users, Norte.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(client, params \\ %{}) do
    client
    |> cast(params, [:cid, :name])
    |> validate_required([:cid, :name])
    |> validate_length(:cid, min: 3, max: 20)
    |> validate_length(:name, min: 3, max: 200)
    |> unique_constraint(:cid)
  end
end
