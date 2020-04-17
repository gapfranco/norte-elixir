defmodule NorteWeb.Schema.Queries.EventQueries do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :event_queries do
    @desc "Get a list of my events"
    field :events, :paginated_events do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.EventResolvers.list_events/3)
    end

    @desc "Get a list of all events"
    field :events_all, :paginated_events do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 10)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:filter, :user_filter)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.EventResolvers.list_all_events/3)
    end

    @desc "Get event by key"
    field :event, :event_type do
      arg(:id, :id)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.EventResolvers.get_event/3)
    end
  end
end
