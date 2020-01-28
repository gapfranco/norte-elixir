defmodule NorteWeb.Schema.Queries.ProcessQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :process_queries do
    @desc "Get a list of all processes"
    field :processes, list_of(:process_type) do
      arg(:offset, :integer)
      arg(:limit, :integer)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ProcessResolvers.list_processes/3)
    end

    @desc "Get process by key"
    field :process, list_of(:process_type) do
      arg(:key, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ProcessResolvers.get_process/3)
    end
  end
end