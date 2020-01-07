defmodule NorteWeb.UnitView do
  use NorteWeb, :view
  alias NorteWeb.UnitView

  def render("index.json", %{units: units}) do
    %{data: render_many(units, UnitView, "unit.json")}
  end

  def render("show.json", %{unit: unit}) do
    %{data: render_one(unit, UnitView, "unit.json")}
  end

  def render("unit.json", %{unit: unit}) do
    %{id: unit.id, key: unit.key, name: unit.name}
  end
end
