defmodule NorteWeb.Schema do
  use Absinthe.Schema

  alias Norte.{Accounts, Base}

  import_types(Absinthe.Type.Custom)

  # Types
  import_types(NorteWeb.Schema.Types.SessionTypes)
  import_types(NorteWeb.Schema.Types.UnitTypes)

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  # Queries
  import_types(NorteWeb.Schema.Queries.UserQueries)
  import_types(NorteWeb.Schema.Queries.SessionQueries)
  import_types(NorteWeb.Schema.Queries.UnitQueries)

  # Mutations
  import_types(NorteWeb.Schema.Mutations.SessionMutations)
  import_types(NorteWeb.Schema.Mutations.UnitMutations)

  query do
    import_fields(:user_queries)
    import_fields(:session_queries)
    import_fields(:unit_queries)
  end

  mutation do
    import_fields(:session_mutations)
    import_fields(:unit_mutations)
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
