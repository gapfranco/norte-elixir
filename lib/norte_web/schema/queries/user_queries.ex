defmodule NorteWeb.Schema.Queries.UserQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :user_queries do
    @desc "Get a list of all users"
    field :users, :paginated_users do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UserResolvers.list_users/3)
    end

    @desc "Get user by uid"
    field :user, :user_type do
      arg(:uid, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UserResolvers.get_user_uid/3)
    end

    @desc "Get a list of all clients"
    field :clients, :paginated_clients do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      resolve(&Resolvers.UserResolvers.list_clients/3)
    end

    @desc "Get client by cid"
    field :client, :client_type do
      arg(:cid, :string)
      resolve(&Resolvers.UserResolvers.get_client_cid/3)
    end
  end
end
