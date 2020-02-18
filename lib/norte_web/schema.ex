defmodule NorteWeb.Schema do
  use Absinthe.Schema

  alias Norte.{Accounts, Processes, Risks, Areas}

  import_types(Absinthe.Type.Custom)

  # Types
  import_types(NorteWeb.Schema.Types.SessionTypes)
  import_types(NorteWeb.Schema.Types.UnitTypes)
  import_types(NorteWeb.Schema.Types.AreaTypes)
  import_types(NorteWeb.Schema.Types.ProcessTypes)
  import_types(NorteWeb.Schema.Types.RiskTypes)
  import_types(NorteWeb.Schema.Types.ItemTypes)

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  # Queries
  import_types(NorteWeb.Schema.Queries.UserQueries)
  import_types(NorteWeb.Schema.Queries.SessionQueries)
  import_types(NorteWeb.Schema.Queries.UnitQueries)
  import_types(NorteWeb.Schema.Queries.AreaQueries)
  import_types(NorteWeb.Schema.Queries.ProcessQueries)
  import_types(NorteWeb.Schema.Queries.RiskQueries)
  import_types(NorteWeb.Schema.Queries.ItemQueries)

  # Mutations
  import_types(NorteWeb.Schema.Mutations.SessionMutations)
  import_types(NorteWeb.Schema.Mutations.UnitMutations)
  import_types(NorteWeb.Schema.Mutations.AreaMutations)
  import_types(NorteWeb.Schema.Mutations.ProcessMutations)
  import_types(NorteWeb.Schema.Mutations.RiskMutations)
  import_types(NorteWeb.Schema.Mutations.ItemMutations)

  query do
    import_fields(:user_queries)
    import_fields(:session_queries)
    import_fields(:unit_queries)
    import_fields(:area_queries)
    import_fields(:process_queries)
    import_fields(:risk_queries)
    import_fields(:item_queries)
  end

  mutation do
    import_fields(:session_mutations)
    import_fields(:unit_mutations)
    import_fields(:area_mutations)
    import_fields(:process_mutations)
    import_fields(:risk_mutations)
    import_fields(:item_mutations)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Clients, Accounts.datasource())
      |> Dataloader.add_source(Users, Accounts.datasource())
      |> Dataloader.add_source(Processes, Processes.datasource())
      |> Dataloader.add_source(Risks, Risks.datasource())
      |> Dataloader.add_source(Areas, Areas.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
