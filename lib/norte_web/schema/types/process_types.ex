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

  @desc "Processes list paginated"
  object :paginated_processes do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:process_type))
  end
end
