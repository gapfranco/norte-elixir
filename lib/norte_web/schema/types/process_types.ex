defmodule NorteWeb.Schema.Types.ProcessTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Process creation"
  object :process_input_type do
    field(:key, :string)
    field(:name, :string)
  end

  @desc "Process register"
  object :process_type do
    field(:id, :id)
    field(:key, :string)
    field(:name, :string)
    field :client, :client_type, resolve: dataloader(Clients)
  end
end
