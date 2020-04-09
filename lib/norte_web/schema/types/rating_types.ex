defmodule NorteWeb.Schema.Types.RatingTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  enum :results do
    value(:conforme)
    value(:falhou)
  end

  @desc "Rating register"
  object :rating_type do
    field(:id, :id)
    field(:date_due, :date)
    field(:date_ok, :date)
    field(:result, :string)
    field(:notes, :string)
    field(:item_key, :string)
    field(:unit_key, :string)
    field(:uid, :string)
    field :item, :item_type, resolve: dataloader(Norte.Items)
    field :unit, :unit_type, resolve: dataloader(Norte.Base)
    field :user, :user_type, resolve: dataloader(Users)
    field :client, :client_type, resolve: dataloader(Clients)
    field :area, :area_type, resolve: dataloader(Norte.Areas)
    field :risk, :risk_type, resolve: dataloader(Norte.Risks)
    field :process, :process_type, resolve: dataloader(Norte.Processes)
  end

  @desc "Ratings list paginated"
  object :paginated_ratings do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:rating_type))
  end
end
