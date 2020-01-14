defmodule NorteWeb.ProcessView do
  use NorteWeb, :view
  alias NorteWeb.ProcessView

  def render("index.json", %{processes: processes}) do
    %{data: render_many(processes, ProcessView, "process.json")}
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
      list: render_many(page.list, ProcessView, "process.json")
    }
  end

  def render("show.json", %{process: process}) do
    %{data: render_one(process, ProcessView, "process.json")}
  end

  def render("process.json", %{process: process}) do
    %{id: process.id, key: process.key, name: process.name, client_id: process.client_id}
  end
end
