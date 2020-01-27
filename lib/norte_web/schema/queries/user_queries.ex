defmodule NorteWeb.Schema.Queries.UserQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :user_queries do
    @desc "Get a list of all users"
    field :users, list_of(:user_type) do
      arg(:offset, :integer)
      arg(:limit, :integer)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UserResolvers.list_users/3)
    end

    @desc "Get a list of all clients"
    field :clients, list_of(:client_type) do
      arg(:offset, :integer)
      arg(:limit, :integer)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      resolve(&Resolvers.UserResolvers.list_clients/3)
    end
  end
end
