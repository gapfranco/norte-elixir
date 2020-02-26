defmodule Norte.Items.Mapping do
  use Ecto.Schema
  import Ecto.Changeset
  alias Norte.{Items, Base, Accounts}

  schema "mappings" do
    # field :item_id, :id
    # field :unit_id, :id
    # field :user_id, :id
    field :item_key, :string, virtual: true
    field :unit_key, :string, virtual: true
    field :user_key, :string, virtual: true
    belongs_to(:item, Norte.Items.Item)
    belongs_to(:unit, Norte.Base.Unit)
    belongs_to(:user, Norte.Accounts.User)
    belongs_to(:client, Norte.Accounts.Client)

    timestamps()
  end

  @doc false
  def changeset(mapping, attrs) do
    mapping
    |> cast(attrs, [:item_id, :unit_id, :user_id, :client_id])
    |> validate_required([:item_id, :unit_id, :user_id, :client_id])
    |> get_item(attrs.client_id)
    |> get_unit(attrs.client_id)
    |> get_user(attrs.client_id)
  end

  defp get_item(%Ecto.Changeset{changes: %{item_key: id}} = changeset, client_id) do
    id =
      case id do
        "null" ->
          nil

        _ ->
          reg = Items.get_item_by_key(id, client_id)
          reg.id
      end

    changeset
    |> put_change(:item_id, id)
  end

  defp get_item(changeset, _), do: changeset

  defp get_unit(%Ecto.Changeset{changes: %{unit_key: id}} = changeset, client_id) do
    id =
      case id do
        "null" ->
          nil

        _ ->
          reg = Base.get_unit_by_key(id, client_id)
          reg.id
      end

    changeset
    |> put_change(:unit_id, id)
  end

  defp get_unit(changeset, _), do: changeset

  defp get_user(%Ecto.Changeset{changes: %{user_key: id}} = changeset, client_id) do
    id =
      case id do
        "null" ->
          nil

        _ ->
          reg = Accounts.get_user_uid(id, client_id)
          reg.id
      end

    changeset
    |> put_change(:user_id, id)
  end

  defp get_user(changeset, _), do: changeset
end