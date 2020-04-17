defmodule NorteWeb.Schema.Types.EventTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Event register"
  object :event_type do
    field(:id, :id)
    field(:event_date, :date)
    field(:text, :string)
    field(:uid, :string)
    field(:item_key, :string)
    field(:item_name, :string)
    field(:unit_key, :string)
    field(:unit_name, :string)
    field(:area_key, :string)
    field(:area_name, :string)
    field(:risk_key, :string)
    field(:risk_name, :string)
    field(:process_key, :string)
    field(:process_name, :string)
    field :user, :user_type, resolve: dataloader(Users)
    field :client, :client_type, resolve: dataloader(Clients)
  end

  @desc "Events list paginated"
  object :paginated_events do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:event_type))
  end
end
