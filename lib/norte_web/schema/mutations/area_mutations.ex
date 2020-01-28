defmodule NorteWeb.Schema.Mutations.AreaMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :area_mutations do
    @desc "Create a new area"
    field :area_create, :area_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.AreaResolvers.create_area/3)
    end

    @desc "Update an area"
    field :area_update, :area_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.AreaResolvers.update_area/3)
    end

    @desc "Delete an area"
    field :area_delete, :area_type do
      arg(:key, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.AreaResolvers.delete_area/3)
    end
  end
end
