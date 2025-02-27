defmodule NorteWeb.Schema.Mutations.UnitMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :unit_mutations do
    @desc "Create a new unit"
    field :unit_create, :unit_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UnitResolvers.create_unit/3)
    end

    @desc "Update a unit"
    field :unit_update, :unit_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UnitResolvers.update_unit/3)
    end

    @desc "Delete a unit"
    field :unit_delete, :unit_type do
      arg(:key, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UnitResolvers.delete_unit/3)
    end
  end
end
