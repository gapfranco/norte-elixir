defmodule NorteWeb.Schema do
  use Absinthe.Schema
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
end
