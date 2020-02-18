defmodule Norte.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Norte.Util
  alias Norte.{Areas, Risks, Processes}

  schema "items" do
    field :base, :date
    field :key, :string
    field :name, :string
    field :period, :string
    field :text, :string
    field :area, :string, virtual: true
    field :risk, :string, virtual: true
    field :process, :string, virtual: true
    field :area_id, :id
    field :risk_id, :id
    field :process_id, :id
    field :up_id, :id
    belongs_to(:client, Norte.Accounts.Client)

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    attrs = Map.update(attrs, :period, nil, &Atom.to_string/1)

    item
    |> cast(attrs, [
      :key,
      :name,
      :text,
      :base,
      :period,
      :client_id,
      :up_id,
      :area,
      :area_id,
      :risk,
      :risk_id,
      :process,
      :process_id
    ])
    |> Util.validate_key_format(:key)
    |> validate_required([:key, :name])
    |> get_area(attrs.client_id)
    |> get_risk(attrs.client_id)
    |> get_process(attrs.client_id)
    |> unique_constraint(:key, name: :items_key_index)
  end

  def update_changeset(item, attrs) do
    attrs = Map.update(attrs, :period, item.period, &Atom.to_string/1)

    item
    |> cast(attrs, [
      :name,
      :text,
      :base,
      :period,
      :client_id,
      :area,
      :area_id,
      :risk,
      :risk_id,
      :process,
      :process_id
    ])
    |> get_area(item.client_id)
    |> get_risk(item.client_id)
    |> get_process(item.client_id)
    |> validate_required([:name])
  end

  defp get_area(%Ecto.Changeset{changes: %{area: id}} = changeset, client_id) do
    id =
      case id do
        "null" ->
          nil

        _ ->
          reg = Areas.get_area_by_key(id, client_id)
          reg.id
      end

    changeset
    |> put_change(:area_id, id)
  end

  defp get_area(changeset, _), do: changeset

  defp get_process(%Ecto.Changeset{changes: %{process: id}} = changeset, client_id) do
    id =
      case id do
        "null" ->
          nil

        _ ->
          reg = Processes.get_process_by_key(id, client_id)
          reg.id
      end

    changeset
    |> put_change(:process_id, id)
  end

  defp get_process(changeset, _), do: changeset

  defp get_risk(%Ecto.Changeset{changes: %{risk: id}} = changeset, client_id) do
    id =
      case id do
        "null" ->
          nil

        _ ->
          reg = Risks.get_risk_by_key(id, client_id)
          reg.id
      end

    changeset
    |> put_change(:risk_id, id)
  end

  defp get_risk(changeset, _), do: changeset
end
