defmodule NorteWeb.Schema.Mutations.ProcessMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :process_mutations do
    @desc "Create a new process"
    field :process_create, :process_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ProcessResolvers.create_process/3)
    end

    @desc "Update a process"
    field :process_update, :process_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ProcessResolvers.update_process/3)
    end

    @desc "Delete a process"
    field :process_delete, :process_type do
      arg(:key, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ProcessResolvers.delete_process/3)
    end
  end
end
