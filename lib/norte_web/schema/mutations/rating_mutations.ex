defmodule NorteWeb.Schema.Mutations.RatingMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :rating_mutations do
    @desc "Create rating"
    field :rating_create, :rating_type do
      arg(:item_id, non_null(:id))
      arg(:unit_id, non_null(:id))
      arg(:user_id, non_null(:id))
      arg(:date_due, non_null(:date))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RatingResolvers.create_rating/3)
    end

    @desc "Update rating"
    field :rating_update, :rating_type do
      arg(:id, non_null(:id))
      arg(:result, type: :results)
      arg(:notes, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RatingResolvers.update_rating/3)
    end

    @desc "Delete rating"
    field :rating_delete, :rating_type do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.RatingResolvers.delete_rating/3)
    end
  end
end
