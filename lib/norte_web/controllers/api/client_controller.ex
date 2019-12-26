defmodule NorteWeb.Api.ClientController do
  use NorteWeb, :controller

  alias Norte.Accounts
  alias Norte.Accounts.Client

  action_fallback NorteWeb.FallbackController

  def sign_up(conn, client_params) do
    case Accounts.create_client(client_params) do
      {:ok, %{client: client, user: user}} ->
        render(conn, "signup.json", client: client, user: user)

      {:error, :user, %{errors: errors}, _} ->
        render(conn, "errors.json", errors: errors)

      {:error, :client, %{errors: errors}, _} ->
        render(conn, "errors.json", errors: errors)
    end
  end

  def index(conn, _params) do
    clients = Accounts.list_clients()
    render(conn, "index.json", clients: clients)
  end

  def show(conn, %{"id" => id}) do
    client = Accounts.get_client!(id)
    render(conn, "show.json", client: client)
  end

  def update(conn, %{"id" => id, "client" => client_params}) do
    client = Accounts.get_client!(id)

    with {:ok, %Client{} = client} <- Accounts.update_client(client, client_params) do
      render(conn, "show.json", client: client)
    end
  end

  def delete(conn, %{"id" => id}) do
    client = Accounts.get_client!(id)

    with {:ok, %Client{}} <- Accounts.delete_client(client) do
      send_resp(conn, :no_content, "")
    end
  end
end
