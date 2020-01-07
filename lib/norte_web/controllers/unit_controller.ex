defmodule NorteWeb.UnitController do
  use NorteWeb, :controller

  alias Norte.Base
  alias Norte.Base.Unit

  action_fallback NorteWeb.Api.FallbackController

  def index(conn, _params) do
    units = Base.list_units()
    render(conn, "index.json", units: units)
  end

  def create(conn, %{"unit" => unit_params}) do
    with {:ok, %Unit{} = unit} <- Base.create_unit(unit_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.unit_path(conn, :show, unit))
      |> render("show.json", unit: unit)
    end
  end

  def show(conn, %{"id" => id}) do
    unit = Base.get_unit!(id)
    render(conn, "show.json", unit: unit)
  end

  def update(conn, %{"id" => id, "unit" => unit_params}) do
    unit = Base.get_unit!(id)

    with {:ok, %Unit{} = unit} <- Base.update_unit(unit, unit_params) do
      render(conn, "show.json", unit: unit)
    end
  end

  def delete(conn, %{"id" => id}) do
    unit = Base.get_unit!(id)

    with {:ok, %Unit{}} <- Base.delete_unit(unit) do
      send_resp(conn, :no_content, "")
    end
  end
end
