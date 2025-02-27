defmodule NorteWeb.Schema.Queries.SessionQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers

  object :session_queries do
    @desc "Get the currently signed-in user"
    field :me, :user_type do
      resolve(&Resolvers.SessionResolvers.me/3)
    end
  end
end
