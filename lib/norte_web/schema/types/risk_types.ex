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

  @desc "Risks list paginated"
  object :paginated_risks do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:risk_type))
  end
end
