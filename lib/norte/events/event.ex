defmodule Norte.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :event_date, :date
    field :text, :string
    field :uid, :string
    field :item_key, :string
    field :item_name, :string
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
    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :event_date,
      :text,
      :uid,
      :item_key,
      :item_name,
      :unit_key,
      :unit_name,
      :area_key,
      :area_name,
      :risk_key,
      :risk_name,
      :process_key,
      :process_name,
      :user_id,
      :client_id
    ])
    |> validate_required([
      :event_date,
      :item_name,
      :text,
      :unit_key,
      :unit_name,
      :user_id,
      :client_id
    ])
  end
end
