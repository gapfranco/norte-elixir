defmodule Norte.Areas do
  @moduledoc """
  The Areas context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo

  alias Norte.Areas.Area
  alias Norte.Pagination

  def list_areas do
    q = from a in Area, order_by: a.key
    Repo.all(q)
  end

  def list_areas(client_id, criteria) do
    query = from a in Area, where: a.client_id == ^client_id
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

  def list_areas_page(params) do
    q = from a in Area, order_by: a.key
    Pagination.list_query(q, params)
  end

  def get_area!(id), do: Repo.get!(Area, id)

  def get_area(id), do: Repo.get(Area, id)

  def get_area_by_key(key, client_id) do
    q = from a in Area, where: a.key == ^key and a.client_id == ^client_id
    Repo.one(q)
  end

  def create_area(attrs \\ %{}) do
    %Area{}
    |> Area.changeset(attrs)
    |> Repo.insert()
  end

  def update_area(%Area{} = area, attrs) do
    area
    |> Area.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_area(%Area{} = area) do
    Repo.delete(area)
  end

  def change_area(%Area{} = area) do
    Area.update_changeset(area, %{})
  end
end
