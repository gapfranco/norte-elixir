defmodule NorteWeb.ProcessController do
  use NorteWeb, :controller

  alias Norte.Processes
  alias Norte.Processes.Process

  action_fallback NorteWeb.FallbackController

  def index(conn, params) do
    page = Processes.list_processes_page(params)
    render(conn, "index_page.json", page: page)
  end

  def create(conn, %{"process" => params}) do
    user = Guardian.Plug.current_resource(conn)
    params = Map.put(params, "client_id", user.client_id)
    pts = String.split(params["key"], ".")

    if length(pts) > 1 do
      {_, arr} = List.pop_at(pts, -1)

      sup =
        Enum.join(arr, ".")
        |> Processes.get_process_by_key()

      if sup === nil do
        send_resp(conn, :bad_request, "Invalid key")
      else
        params = Map.put(params, "up_id", sup.id)
        write_process(conn, params)
      end
    else
      write_process(conn, params)
    end
  end

  defp write_process(conn, params) do
    with {:ok, %Process{} = process} <- Processes.create_process(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.unit_path(conn, :show, process))
      |> render("show.json", process: process)
    end
  end

  def show(conn, %{"id" => id}) do
    process = Processes.get_process!(id)
    render(conn, "show.json", process: process)
  end

  def update(conn, %{"id" => id, "process" => process_params}) do
    process = Processes.get_process!(id)

    with {:ok, %Process{} = process} <- Processes.update_process(process, process_params) do
      render(conn, "show.json", process: process)
    end
  end

  def delete(conn, %{"id" => id}) do
    process = Processes.get_process!(id)

    with {:ok, %Process{}} <- Processes.delete_process(process) do
      send_resp(conn, :no_content, "")
    end
  end
end
