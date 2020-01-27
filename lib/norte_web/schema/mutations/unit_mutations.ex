defmodule NorteWeb.Schema.Mutations.UnitMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers

  object :unit_mutations do
    @desc "Create a new unit"
    field :unit_create, :unit_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      resolve(&Resolvers.UnitResolvers.create_unit/3)
    end
  end
end
