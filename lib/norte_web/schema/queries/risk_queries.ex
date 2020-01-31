defmodule NorteWeb.Schema.Queries.RiskQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :risk_queries do
    @desc "Get a list of all risks"
    field :risks, :paginated_risks do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RiskResolvers.list_risks/3)
    end

    @desc "Get risk by key"
    field :risk, :risk_type do
      arg(:key, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RiskResolvers.get_risk/3)
    end
  end
end
