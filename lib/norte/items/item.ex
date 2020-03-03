defmodule Norte.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Norte.Util
  alias Norte.{Areas, Risks, Processes}

  schema "items" do
    field :base, :date
    field :key, :string
    field :name, :string
    field :freq, :string
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
    attrs =
      Map.update(attrs, :freq, nil, &Util.atom_field/1)
      |> check_area()
      |> check_risk()
      |> check_process()

    item
    |> cast(attrs, [
      :key,
      :name,
      :text,
      :base,
      :freq,
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
    |> unique_constraint(:key, name: :items_key_index)
  end

  def update_changeset(item, attrs) do
    attrs =
      Map.update(attrs, :freq, nil, &Util.atom_field/1)
      |> check_area()
      |> check_risk()
      |> check_process()

    item
    |> cast(attrs, [
      :name,
      :text,
      :base,
      :freq,
      :client_id,
      :area_key,
      :area_id,
      :risk_key,
      :risk_id,
      :process_key,
      :process_id
    ])
    |> validate_required([:name])
  end

  defp check_area(attrs) do
    case Map.fetch(attrs, :area_key) do
      {:ok, _} ->
        if attrs.area_key !== nil do
          reg = Areas.get_area_by_key(attrs.area_key, attrs.client_id)
          Map.put(attrs, :area_id, reg.id)
        else
          Map.put(attrs, :area_id, nil)
        end

      _ ->
        attrs
    end
  end

  defp check_risk(attrs) do
    case Map.fetch(attrs, :risk_key) do
      {:ok, _} ->
        if attrs.risk_key !== nil do
          reg = Risks.get_risk_by_key(attrs.risk_key, attrs.client_id)
          Map.put(attrs, :risk_id, reg.id)
        else
          Map.put(attrs, :risk_id, nil)
        end

      _ ->
        attrs
    end
  end

  defp check_process(attrs) do
    case Map.fetch(attrs, :process_key) do
      {:ok, _} ->
        if attrs.process_key !== nil do
          reg = Processes.get_process_by_key(attrs.process_key, attrs.client_id)
          Map.put(attrs, :process_id, reg.id)
        else
          Map.put(attrs, :process_id, nil)
        end

      _ ->
        attrs
    end
  end
end
