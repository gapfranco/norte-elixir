defmodule NorteWeb.AreaView do
  use NorteWeb, :view
  alias NorteWeb.AreaView

  def render("index.json", %{areas: areas}) do
    %{data: render_many(areas, AreaView, "area.json")}
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
      list: render_many(page.list, AreaView, "area.json")
    }
  end

  def render("show.json", %{area: area}) do
    %{data: render_one(area, AreaView, "area.json")}
  end

  def render("area.json", %{area: area}) do
    %{id: area.id, key: area.key, name: area.name, client_id: area.client_id}
  end
end
