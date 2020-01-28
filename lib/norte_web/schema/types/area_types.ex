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
end
