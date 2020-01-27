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
end
