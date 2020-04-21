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
    field(:item_name, :string)
    field(:item_text, :string)
    field(:unit_key, :string)
    field(:unit_name, :string)
    field(:area_key, :string)
    field(:area_name, :string)
    field(:risk_key, :string)
    field(:risk_name, :string)
    field(:process_key, :string)
    field(:process_name, :string)
    field(:uid, :string)
    field :user, :user_type, resolve: dataloader(Users)
    field :client, :client_type, resolve: dataloader(Clients)
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

  # @desc "Ratings list"
  # object :ratings_list do
  #   field(:list, list_of(:rating_type))
  # end
end
