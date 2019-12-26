defmodule NorteWeb.Api.UserController do
  use NorteWeb, :controller

  alias Norte.Accounts
  alias Norte.Accounts.User
  alias Norte.Password

  action_fallback NorteWeb.FallbackController

  def sign_in(conn, %{"uid" => uid, "password" => password}) do
    case Password.token_sign_in(uid, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    IO.inspect(user.client_id)

    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    user_params = Map.put(user_params, "client_id", user.client_id)

    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
