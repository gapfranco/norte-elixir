defmodule Norte.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :event_date, :date
    field :key, :string
    field :name, :string
    field :text, :string
    field :uid, :string
    field :unit_key, :string
    belongs_to(:user, Norte.Accounts.User)
    belongs_to(:unit, Norte.Base.Unit)
    belongs_to(:client, Norte.Accounts.Client)
    belongs_to(:area, Norte.Areas.Area)
    belongs_to(:process, Norte.Processes.Process)
    belongs_to(:risk, Norte.Risks.Risk)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :event_date,
      :key,
      :name,
      :text,
      :uid,
      :unit_key,
      :unit_id,
      :area_id,
      :risk_id,
      :process_id,
      :user_id,
      :client_id
    ])
    |> validate_required([
      :event_date,
      :name,
      :text,
      :unit_id,
      :user_id,
      :client_id
    ])
  end
end
