defmodule NorteWeb.UnitView do
  use NorteWeb, :view
  alias NorteWeb.UnitView

  def render("index.json", %{units: units}) do
    %{data: render_many(units, UnitView, "unit.json")}
  end

  def render("index_page.json", %{page: page}) do
    %{
      count: page.count,
      first: page.first,
      has_next: page.has_next,
      has_prev: page.has_prev,
      last: page.last,
      next_page: page.next_page,
      page: page.page,
      prev_page: page.prev_page,
      list: render_many(page.list, UnitView, "unit.json")
    }
  end

  def render("show.json", %{unit: unit}) do
    %{data: render_one(unit, UnitView, "unit.json")}
  end

  def render("unit.json", %{unit: unit}) do
    %{id: unit.id, key: unit.key, name: unit.name, client_id: unit.client_id}
  end
end
