defmodule NorteWeb.UserController do
  use NorteWeb, :controller

  alias Norte.Accounts
  alias Norte.Accounts.User
  alias Norte.Password
  alias Norte.{Email, Mailer}

  action_fallback NorteWeb.FallbackController

  def sign_in(conn, %{"uid" => uid, "password" => password}) do
    case Password.token_sign_in(uid, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end

  def forgot_password(conn, %{"uid" => uid}) do
    user = Accounts.get_user_uid(uid)

    if user == nil do
      render(conn, "errors.json", errors: [user: {"Invalid user", []}])
    else
      client = Accounts.get_client(user.client_id)

      token =
        :crypto.strong_rand_bytes(10)
        |> Base.url_encode64()
        |> binary_part(0, 10)
        |> String.downcase()

      date = DateTime.utc_now() |> DateTime.add(2 * 60 * 60 * 24)
      Accounts.update_user(user, %{token: token, token_date: date})
      Email.forgot_password_email(user.email, uid, client.cid, token) |> Mailer.deliver_now()
      send_resp(conn, :no_content, "")
    end
  end

  def create_password(conn, %{"uid" => uid, "token" => token, "password" => password}) do
    user = Accounts.get_user_uid(uid)

    if user == nil do
      render(conn, "errors.json", errors: [user: {"Invalid user", []}])
    else
      date = DateTime.utc_now()

      if user.token == token and user.token_date >= date do
        case Accounts.update_user_with_password(user, %{
               password: password,
               password_confirmation: password,
               expired: false,
               token: nil,
               token_date: nil
             }) do
          {:ok, _} ->
            send_resp(conn, :no_content, "")

          {:error, :user, %{errors: errors}, _} ->
            render(conn, "errors.json", errors: errors)
        end
      else
        render(conn, "errors.json", errors: [token: {"Token inválido", []}])
      end
    end
  end

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    page = Accounts.list_users_page(user.client_id, params)
    render(conn, "index_page.json", page: page)
  end

  # def index(conn, params) do
  #   page = Areas.list_areas_page(params)
  #   render(conn, "index_page.json", page: page)
  # end

  def create(conn, %{"user" => params}) do
    user = Guardian.Plug.current_resource(conn)
    params = Map.put(params, "client_id", user.client_id)

    with {:ok, %User{} = user} <- Accounts.create_user(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Accounts.get_user(id, current_user.client_id)
    render(conn, "show.json", user: user)
  end

  def show_uid(conn, %{"uid" => uid}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Accounts.get_user_uid(uid, current_user.client_id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Accounts.get_user(id, current_user.client_id)

    if user != nil do
      with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
        render(conn, "show.json", user: user)
      end
    else
      send_resp(conn, :bad_request, "Invalid user")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Accounts.get_user(id, current_user.client_id)

    if user != nil do
      Accounts.delete_user(user)
      send_resp(conn, :no_content, "")
    else
      send_resp(conn, :bad_request, "Invalid user")
    end
  end
end
