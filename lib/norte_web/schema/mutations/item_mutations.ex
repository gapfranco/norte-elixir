defmodule NorteWeb.Schema.Mutations.ItemMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

  object :item_mutations do
    @desc "Create a new item"
    field :item_create, :item_type do
      arg(:key, non_null(:string))
      arg(:name, non_null(:string))
      arg(:text, :string)
      arg(:freq, type: :frequency)
      arg(:base, :date)
      arg(:area_key, :string)
      arg(:risk_key, :string)
      arg(:process_key, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ItemResolvers.create_item/3)
    end

    @desc "Update an item"
    field :item_update, :item_type do
      arg(:key, non_null(:string))
      arg(:name, :string)
      arg(:text, :string)
      arg(:freq, type: :frequency)
      arg(:base, :date)
      arg(:area_key, :string)
      arg(:risk_key, :string)
      arg(:process_key, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ItemResolvers.update_item/3)
    end

    @desc "Delete an item"
    field :item_delete, :item_type do
      arg(:key, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ItemResolvers.delete_item/3)
    end

    @desc "Create a mapping"
    field :mapping_create, :mapping_type do
      arg(:item_key, :string)
      arg(:unit_key, :string)
      arg(:user_key, :string)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.ItemResolvers.create_mapping/3)
    end
  end
end
