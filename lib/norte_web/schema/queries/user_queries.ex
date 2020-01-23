defmodule NorteWeb.Schema.Queries.UserQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :user_queries do
    @desc "Get a list of all users"
    field :users, list_of(:user_type) do
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UserResolvers.list_users/3)
    end
  end
end
