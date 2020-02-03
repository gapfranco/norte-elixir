defmodule Norte.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Norte.Util

  schema "items" do
    field :base, :date
    field :key, :string
    field :name, :string
    field :period, :integer
    field :text, :string
    field :area_id, :id
    field :risk_id, :id
    field :process_id, :id
    field :up_id, :id
    belongs_to(:client, Norte.Accounts.Client)

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:key, :name, :text, :base, :period, :client_id, :up_id])
    |> Util.validate_key_format(:key)
    |> validate_required([:key, :name, :text, :base, :period])
    |> unique_constraint(:key, name: :items_key_index)
  end

  def update_changeset(unit, attrs) do
    unit
    |> cast(attrs, [:name, :text, :base, :period])
    |> validate_required([:name, :text, :base, :period])
  end
end
