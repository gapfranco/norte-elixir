defmodule Norte.Base do
  @moduledoc """
  The Base context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo

  alias Norte.Base.Unit
  alias Norte.Pagination

  def list_units do
    q = from u in Unit, order_by: u.key
    Repo.all(q)
  end

  def list_units(client_id, criteria) do
    query = from u in Unit, where: u.client_id == ^client_id
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

  def list_units_page(params) do
    q = from u in Unit, order_by: u.key
    Pagination.list_query(q, params)
  end

  def get_unit!(id), do: Repo.get!(Unit, id)

  def get_unit(id), do: Repo.get(Unit, id)

  def get_unit_by_key(key, client_id) do
    q = from u in Unit, where: u.key == ^key and u.client_id == ^client_id
    Repo.one(q)
  end

  def create_unit(attrs \\ %{}) do
    %Unit{}
    |> Unit.changeset(attrs)
    |> Repo.insert()
  end

  def update_unit(%Unit{} = unit, attrs) do
    unit
    |> Unit.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_unit(%Unit{} = unit) do
    Repo.delete(unit)
  end

  def change_unit(%Unit{} = unit) do
    Unit.update_changeset(unit, %{})
  end

  # Dataloader

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
