defmodule NorteWeb.Schema do
  use Absinthe.Schema

  alias Norte.Accounts

  import_types(Absinthe.Type.Custom)

  # Types
  import_types(NorteWeb.Schema.Types.SessionTypes)

  # Queries
  import_types(NorteWeb.Schema.Queries.UserQueries)

  # Mutations
  import_types(NorteWeb.Schema.Mutations.SessionMutations)

  query do
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:session_mutations)
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
