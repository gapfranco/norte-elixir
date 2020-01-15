defmodule NorteWeb.RiskController do
  use NorteWeb, :controller

  alias Norte.Risks
  alias Norte.Risks.Risk

  action_fallback NorteWeb.FallbackController

  def index(conn, params) do
    page = Risks.list_risks_page(params)
    render(conn, "index_page.json", page: page)
  end

  def create(conn, %{"risk" => params}) do
    user = Guardian.Plug.current_resource(conn)
    params = Map.put(params, "client_id", user.client_id)
    pts = String.split(params["key"], ".")

    if length(pts) > 1 do
      {_, arr} = List.pop_at(pts, -1)

      sup =
        Enum.join(arr, ".")
        |> Risks.get_risk_by_key()

      if sup === nil do
        send_resp(conn, :bad_request, "Invalid key")
      else
        params = Map.put(params, "up_id", sup.id)
        write_risk(conn, params)
      end
    else
      write_risk(conn, params)
    end
  end

  defp write_risk(conn, params) do
    with {:ok, %Risk{} = risk} <- Risks.create_risk(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.risk_path(conn, :show, risk))
      |> render("show.json", risk: risk)
    end
  end

  def show(conn, %{"id" => id}) do
    risk = Risks.get_risk!(id)
    render(conn, "show.json", risk: risk)
  end

  def update(conn, %{"id" => id, "risk" => risk_params}) do
    risk = Risks.get_risk!(id)

    with {:ok, %Risk{} = risk} <- Risks.update_risk(risk, risk_params) do
      render(conn, "show.json", risk: risk)
    end
  end

  def delete(conn, %{"id" => id}) do
    risk = Risks.get_risk!(id)

    with {:ok, %Risk{}} <- Risks.delete_risk(risk) do
      send_resp(conn, :no_content, "")
    end
  end
end
