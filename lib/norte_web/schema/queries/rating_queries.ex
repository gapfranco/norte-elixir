defmodule NorteWeb.Schema.Queries.RatingQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :rating_queries do
    @desc "Get a list of all ratings"
    field :ratings, :paginated_ratings do
      arg(:user_id, non_null(:id))
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RatingResolvers.list_ratings/3)
    end

    @desc "Get rating by key"
    field :rating, :rating_type do
      arg(:id, :id)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RatingResolvers.get_rating/3)
    end
  end
end
