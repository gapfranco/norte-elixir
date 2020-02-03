defmodule Norte.Items do
  @moduledoc """
  The Items context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo

  alias Norte.Items.Item
  alias Norte.Pagination

  def list_items do
    q = from a in Item, order_by: a.key
    Repo.all(q)
  end

  def list_items(client_id, criteria) do
    query = from a in Item, where: a.client_id == ^client_id
    Pagination.paginate(query, criteria, :key, &filter_with/2)
  end

  defp filter_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where:
            ilike(q.name, ^pattern) or
              ilike(q.key, ^pattern)
    end)
  end

  def list_items_page(params) do
    q = from a in Item, order_by: a.key
    Pagination.list_query(q, params)
  end

  def get_item!(id), do: Repo.get!(Item, id)

  def get_item(id), do: Repo.get(Item, id)

  def get_item_by_key(key, client_id) do
    q = from a in Item, where: a.key == ^key and a.client_id == ^client_id
    Repo.one(q)
  end

  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item) do
    Item.update_changeset(item, %{})
  end
end
