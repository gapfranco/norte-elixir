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

  def list_units_page(page \\ 1, sz \\ 10) do
    # IO.inspect(sz)
    q = from u in Unit, order_by: u.key
    Pagination.page(q, page, per_page: sz)
  end

  def get_unit!(id), do: Repo.get!(Unit, id)

  def get_unit(id), do: Repo.get(Unit, id)

  def get_unit_by_key(key) do
    q = from u in Unit, where: u.key == ^key
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
end
