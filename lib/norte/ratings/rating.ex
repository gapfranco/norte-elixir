defmodule Norte.Ratings.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  alias Norte.Util
  alias Norte.Areas
  alias Norte.Risks
  alias Norte.Processes

  schema "ratings" do
    field :date_due, :date
    field :date_ok, :date
    field :result, :string
    field :notes, :string
    field :uid, :string
    field :item_key, :string
    field :item_name, :string
    field :item_text, :string
    field :unit_key, :string
    field :unit_name, :string
    field :area_key, :string
    field :area_name, :string
    field :risk_key, :string
    field :risk_name, :string
    field :process_key, :string
    field :process_name, :string
    belongs_to(:user, Norte.Accounts.User)
    belongs_to(:client, Norte.Accounts.Client)
    belongs_to(:alert_user, Norte.Accounts.User, foreign_key: :alert_user_id)

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    attrs =
      Map.update(attrs, :result, nil, &Util.atom_field/1)
      |> check_result()
      |> check_area()
      |> check_risk()
      |> check_process()
      |> Map.drop([:area_id, :risk_id, :process_id])

    rating
    |> cast(attrs, [
      :date_due,
      :date_ok,
      :result,
      :notes,
      :uid,
      :item_key,
      :item_name,
      :item_text,
      :unit_key,
      :unit_name,
      :area_key,
      :area_name,
      :risk_key,
      :risk_name,
      :process_key,
      :process_name,
      :user_id,
      :alert_user_id,
      :client_id
    ])
    |> validate_required([
      :item_key,
      :item_name,
      :date_due,
      :unit_key,
      :unit_name,
      :user_id,
      :client_id
    ])
    |> unique_constraint(:item_key, name: :ratings_units_index)
  end

  defp check_result(attrs) do
    case Map.fetch(attrs, :result) do
      {:ok, _} ->
        if attrs.result !== nil do
          Map.put(attrs, :date_ok, Date.utc_today())
        else
          Map.put(attrs, :date_ok, nil)
        end

      _ ->
        attrs
    end
  end

  defp check_area(attrs) do
    case Map.fetch(attrs, :area_id) do
      {:ok, id} when not is_nil(id) ->
        reg = Areas.get_area(id)

        attrs
        |> Map.put(:area_key, reg.key)
        |> Map.put(:area_name, reg.name)

      _ ->
        attrs
    end
  end

  defp check_risk(attrs) do
    case Map.fetch(attrs, :risk_id) do
      {:ok, id} when not is_nil(id) ->
        reg = Risks.get_risk(id)

        attrs
        |> Map.put(:risk_key, reg.key)
        |> Map.put(:risk_name, reg.name)

      _ ->
        attrs
    end
  end

  defp check_process(attrs) do
    case Map.fetch(attrs, :process_id) do
      {:ok, id} when not is_nil(id) ->
        reg = Processes.get_process(id)

        attrs
        |> Map.put(:process_key, reg.key)
        |> Map.put(:process_name, reg.name)

      _ ->
        attrs
    end
  end
end
