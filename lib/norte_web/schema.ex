defmodule NorteWeb.Schema do
  use Absinthe.Schema

  alias Norte.Accounts

  import_types(Absinthe.Type.Custom)

  # Types
  import_types(NorteWeb.Schema.Types.SessionTypes)
  import_types(NorteWeb.Schema.Types.UnitTypes)
  import_types(NorteWeb.Schema.Types.AreaTypes)
  import_types(NorteWeb.Schema.Types.ProcessTypes)

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

  # Mutations
  import_types(NorteWeb.Schema.Mutations.SessionMutations)
  import_types(NorteWeb.Schema.Mutations.UnitMutations)
  import_types(NorteWeb.Schema.Mutations.AreaMutations)
  import_types(NorteWeb.Schema.Mutations.ProcessMutations)

  query do
    import_fields(:user_queries)
    import_fields(:session_queries)
    import_fields(:unit_queries)
    import_fields(:area_queries)
    import_fields(:process_queries)
  end

  mutation do
    import_fields(:session_mutations)
    import_fields(:unit_mutations)
    import_fields(:area_mutations)
    import_fields(:process_mutations)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Clients, Accounts.datasource())
      |> Dataloader.add_source(Users, Accounts.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
