defmodule Norte.Ratings.Rating do
  use Ecto.Schema
  import Ecto.Changeset
  alias Norte.Util

  schema "ratings" do
    field :date_due, :date
    field :date_ok, :date
    field :result, :string
    field :notes, :string

    belongs_to(:item, Norte.Items.Item)
    belongs_to(:unit, Norte.Base.Unit)
    belongs_to(:user, Norte.Accounts.User)
    belongs_to(:client, Norte.Accounts.Client)
    belongs_to(:area, Norte.Areas.Area)
    belongs_to(:process, Norte.Processes.Process)
    belongs_to(:risk, Norte.Risks.Risk)

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    attrs = Map.update(attrs, :result, nil, &Util.atom_field/1) |> check_result()

    rating
    |> cast(attrs, [
      :item_id,
      :unit_id,
      :user_id,
      :date_due,
      :date_ok,
      :result,
      :notes,
      :area_id,
      :risk_id,
      :process_id,
      :client_id
    ])
    |> validate_required([:item_id, :date_due, :unit_id, :user_id, :client_id])
    |> unique_constraint(:item_id, name: :ratings_units_index)
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
end
