defmodule NorteWeb.Schema.Types.RiskTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Risk creation"
  object :risk_input_type do
    field(:key, :string)
    field(:name, :string)
  end

  @desc "Risk register"
  object :risk_type do
    field(:id, :id)
    field(:key, :string)
    field(:name, :string)
    field :client, :client_type, resolve: dataloader(Clients)
  end
end
