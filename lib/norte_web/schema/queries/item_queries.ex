defmodule NorteWeb.Schema.Queries.ItemQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :item_queries do
    @desc "Get a list of all items"
    field :items, :paginated_items do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ItemResolvers.list_items/3)
    end

    @desc "Get item by key"
    field :item, :item_type do
      arg(:key, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ItemResolvers.get_item/3)
    end
  end
end
