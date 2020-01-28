defmodule NorteWeb.Schema.Mutations.RiskMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :risk_mutations do
    @desc "Create a new risk"
    field :risk_create, :risk_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RiskResolvers.create_risk/3)
    end

    @desc "Update an risk"
    field :risk_update, :risk_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RiskResolvers.update_risk/3)
    end

    @desc "Delete an risk"
    field :risk_delete, :risk_type do
      arg(:key, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RiskResolvers.delete_risk/3)
    end
  end
end
