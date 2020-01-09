defmodule NorteWeb.UnitController do
  use NorteWeb, :controller

  alias Norte.Base
  alias Norte.Base.Unit

  action_fallback NorteWeb.FallbackController

  def index(conn, params) do
    page = Base.list_units_page(params)
    render(conn, "index_page.json", page: page)
  end

  def create(conn, %{"unit" => unit_params}) do
    user = Guardian.Plug.current_resource(conn)
    unit_params = Map.put(unit_params, "client_id", user.client_id)
    pts = String.split(unit_params["key"], ".")

    if length(pts) > 1 do
      {_, arr} = List.pop_at(pts, -1)

      sup =
        Enum.join(arr, ".")
        |> Base.get_unit_by_key()

      if sup === nil do
        send_resp(conn, :bad_request, "Invalid key")
      else
        unit_params = Map.put(unit_params, "up_id", sup.id)
        write_unit(conn, unit_params)
      end
    else
      write_unit(conn, unit_params)
    end
  end

  defp write_unit(conn, unit_params) do
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
