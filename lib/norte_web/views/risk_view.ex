defmodule NorteWeb.RiskView do
  use NorteWeb, :view
  alias NorteWeb.RiskView

  def render("index.json", %{risks: risks}) do
    %{data: render_many(risks, RiskView, "risk.json")}
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
      list: render_many(page.list, RiskView, "risk.json")
    }
  end

  def render("show.json", %{risk: risk}) do
    %{data: render_one(risk, RiskView, "risk.json")}
  end

  def render("risk.json", %{risk: risk}) do
    %{id: risk.id, key: risk.key, name: risk.name, client_id: risk.client_id}
  end
end
