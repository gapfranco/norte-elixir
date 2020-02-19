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
    field :area_key, :string, virtual: true
    field :risk_key, :string, virtual: true
    field :process_key, :string, virtual: true
    field :up_id, :id
    belongs_to(:client, Norte.Accounts.Client)
    belongs_to(:area, Norte.Areas.Area)
    belongs_to(:process, Norte.Processes.Process)
    belongs_to(:risk, Norte.Risks.Risk)

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
      :area_key,
      :area_id,
      :risk_key,
      :risk_id,
      :process_key,
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
      :area_key,
      :area_id,
      :risk_key,
      :risk_id,
      :process_key,
      :process_id
    ])
    |> get_area(item.client_id)
    |> get_risk(item.client_id)
    |> get_process(item.client_id)
    |> validate_required([:name])
  end

  defp get_area(%Ecto.Changeset{changes: %{area_key: id}} = changeset, client_id) do
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

  defp get_process(%Ecto.Changeset{changes: %{process_key: id}} = changeset, client_id) do
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

  defp get_risk(%Ecto.Changeset{changes: %{risk_key: id}} = changeset, client_id) do
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
