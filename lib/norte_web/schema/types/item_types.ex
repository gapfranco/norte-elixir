defmodule NorteWeb.Schema.Types.ItemTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  enum :frequency do
    value(:diario)
    value(:semanal)
    value(:mensal)
    value(:bimestral)
    value(:trimestral)
    value(:semestral)
    value(:anual)
  end

  @desc "Item register"
  object :item_type do
    field(:id, :id)
    field(:key, :string)
    field(:name, :string)
    field(:text, :string)
    field(:base, :date)
    field(:freq, :string)
    field :client, :client_type, resolve: dataloader(Clients)
    field :area, :area_type, resolve: dataloader(Norte.Areas)
    field :risk, :risk_type, resolve: dataloader(Norte.Risks)
    field :process, :process_type, resolve: dataloader(Norte.Processes)
  end

  @desc "Items list paginated"
  object :paginated_items do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:item_type))
  end

  @desc "Mapping register"
  object :mapping_type do
    field(:id, :id)
    field :client, :client_type, resolve: dataloader(Clients)
    field :unit, :unit_type, resolve: dataloader(Norte.Base)
    field :user, :user_type, resolve: dataloader(Users)
  end

  @desc "Mappings list paginated"
  object :paginated_mappings do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:mapping_type))
  end
end
