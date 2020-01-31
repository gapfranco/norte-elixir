defmodule NorteWeb.Schema.Queries.AreaQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :area_queries do
    @desc "Get a list of all areas"
    field :areas, :paginated_areas do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.AreaResolvers.list_areas/3)
    end

    @desc "Get area by key"
    field :area, :area_type do
      arg(:key, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.AreaResolvers.get_area/3)
    end
  end
end
