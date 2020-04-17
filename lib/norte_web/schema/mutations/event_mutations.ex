defmodule NorteWeb.Schema.Mutations.EventMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :event_mutations do
    @desc "Create event"
    field :event_create, :event_type do
      arg(:rating_id, non_null(:id))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.EventResolvers.create_event/3)
    end

    # @desc "Update event"
    # field :event_update, :event_type do
    #   arg(:id, non_null(:id))
    #   arg(:result, type: :results)
    #   arg(:notes, :string)
    #   middleware(Middleware.Authorize, :any)
    #   resolve(&Resolvers.EventResolvers.update_event/3)
    # end

    @desc "Delete event"
    field :event_delete, :event_type do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.EventResolvers.delete_event/3)
    end
  end
end
