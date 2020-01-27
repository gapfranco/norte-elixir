defmodule NorteWeb.Schema.Queries.UnitQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :unit_queries do
    @desc "Get a list of all units"
    field :units, list_of(:unit_type) do
      arg(:offset, :integer)
      arg(:limit, :integer)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UnitResolvers.list_units/3)
    end

    @desc "Get a unit by key"
    field :unit, list_of(:unit_type) do
      arg(:key, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UnitResolvers.get_unit/3)
    end
  end
end
