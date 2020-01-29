defmodule NorteWeb.Schema.Types.AreaTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Area creation"
  object :area_input_type do
    field(:key, :string)
    field(:name, :string)
  end

  @desc "Area register"
  object :area_type do
    field(:id, :id)
    field(:key, :string)
    field(:name, :string)
    field :client, :client_type, resolve: dataloader(Clients)
  end

  @desc "Areas list paginated"
  object :paginated_areas do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:area_type))
  end
end
