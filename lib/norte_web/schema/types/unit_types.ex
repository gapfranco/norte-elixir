defmodule NorteWeb.Schema.Types.UnitTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Unit creation"
  object :unit_input_type do
    field(:key, :string)
    field(:name, :string)
  end

  @desc "Unit register"
  object :unit_type do
    field(:id, :id)
    field(:key, :string)
    field(:name, :string)
    field :client, :client_type, resolve: dataloader(Clients)
  end

  @desc "Units list paginated"
  object :paginated_units do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:unit_type))
  end
end
