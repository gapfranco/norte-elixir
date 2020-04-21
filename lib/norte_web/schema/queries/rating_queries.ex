defmodule NorteWeb.Schema.Queries.RatingQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :rating_queries do
    @desc "Get a list of my ratings"
    field :ratings, :paginated_ratings do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RatingResolvers.list_ratings/3)
    end

    @desc "Get a list of all ratings"
    field :ratings_all, :paginated_ratings do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RatingResolvers.list_all_ratings/3)
    end

    @desc "Get rating by key"
    field :rating, :rating_type do
      arg(:id, :id)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RatingResolvers.get_rating/3)
    end

    @desc "Report on ratings"
    field :ratings_report, list_of(:rating_type) do
      arg(:date_ini, :date)
      arg(:date_end, :date)
      arg(:item, :string)
      arg(:unit, :string)
      arg(:user, :string)
      arg(:area, :string)
      arg(:risk, :string)
      arg(:process, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RatingResolvers.ratings_report/3)
    end
  end
end
