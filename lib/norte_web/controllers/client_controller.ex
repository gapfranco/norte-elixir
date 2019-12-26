defmodule NorteWeb.ClientController do
  use NorteWeb, :controller

  alias Norte.Accounts

  def show(conn, %{"id" => id}) do
    client = Accounts.get_client!(id)
    render(conn, "show.html", client: client)
  end

  def new(conn, _params) do
    client = Accounts.new_client()
    render(conn, "new.html", client: client)
  end

  def create(conn, %{"user" => client_params}) do
    create(conn, %{"client" => client_params})
  end

  def create(conn, %{"client" => client_params}) do
    case Accounts.insert_client(client_params) do
      {:ok, _} ->
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, :user, user, _} ->
        render(conn, "new.html", client: user)

      {:error, :client, client, _} ->
        render(conn, "new.html", client: client)
    end
  end
end
