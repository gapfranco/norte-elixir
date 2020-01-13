defmodule NorteWeb.AreaController do
  use NorteWeb, :controller

  alias Norte.Areas
  alias Norte.Areas.Area

  action_fallback NorteWeb.FallbackController

  def index(conn, params) do
    page = Areas.list_areas_page(params)
    render(conn, "index_page.json", page: page)
  end

  def create(conn, %{"area" => params}) do
    user = Guardian.Plug.current_resource(conn)
    params = Map.put(params, "client_id", user.client_id)
    pts = String.split(params["key"], ".")

    if length(pts) > 1 do
      {_, arr} = List.pop_at(pts, -1)

      sup =
        Enum.join(arr, ".")
        |> Areas.get_area_by_key()

      if sup === nil do
        send_resp(conn, :bad_request, "Invalid key")
      else
        params = Map.put(params, "up_id", sup.id)
        write_area(conn, params)
      end
    else
      write_area(conn, params)
    end
  end

  defp write_area(conn, params) do
    with {:ok, %Area{} = area} <- Areas.create_area(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.unit_path(conn, :show, area))
      |> render("show.json", area: area)
    end
  end

  def show(conn, %{"id" => id}) do
    area = Areas.get_area!(id)
    render(conn, "show.json", area: area)
  end

  def update(conn, %{"id" => id, "area" => area_params}) do
    area = Areas.get_area!(id)

    with {:ok, %Area{} = area} <- Areas.update_area(area, area_params) do
      render(conn, "show.json", area: area)
    end
  end

  def delete(conn, %{"id" => id}) do
    area = Areas.get_area!(id)

    with {:ok, %Area{}} <- Areas.delete_area(area) do
      send_resp(conn, :no_content, "")
    end
  end
end
