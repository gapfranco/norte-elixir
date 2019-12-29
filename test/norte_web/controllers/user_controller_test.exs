defmodule NorteWeb.UserControllerTest do
  use NorteWeb.ConnCase

  alias Norte.Accounts
  # alias Norte.Accounts.User
  alias Norte.Password

  @valid_attrs %{
    cid: "tst",
    name: "Teste",
    uid: "usr@tst",
    username: "test-user",
    email: "teste@example.com",
    password: "secret",
    password_confirmation: "secret"
  }

  def client_fixture(attrs \\ %{}) do
    {:ok, %{client: client, user: user}} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_client()

    user = Map.put(user, :password, nil)
    {:ok, token, _claims} = Password.token_sign_in("usr@tst", "secret")
    {client, user, token}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "authentication" do
    test "sign-up client and user whith valid data", %{conn: conn} do
      conn = post(conn, Routes.client_path(conn, :sign_up), @valid_attrs)

      assert %{
               "client" => %{"cid" => cid, "name" => name} = client,
               "user" => %{"uid" => uid, "email" => email, "username" => username} = user
             } = json_response(conn, 200)

      assert cid = "tst"
      assert name = "Teste"
      assert uid == "usr@tst"
      assert email == "teste@example.com"
      assert username == "test-user"
    end

    test "sign-in with valid user", %{conn: conn} do
      client_fixture()
      conn = post(conn, Routes.user_path(conn, :sign_in), %{uid: "usr@tst", password: "secret"})
      assert %{"jwt" => jwt} = json_response(conn, 200)
    end

    test "sign-in with invalid user/password", %{conn: conn} do
      client_fixture()
      conn = post(conn, Routes.user_path(conn, :sign_in), %{uid: "usr@tst", password: "errada"})
      assert json_response(conn, 401)
    end

    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, Routes.user_path(conn, :index)),
          get(conn, Routes.user_path(conn, :show, "123")),
          put(conn, Routes.user_path(conn, :update, "123", %{})),
          post(conn, Routes.user_path(conn, :create, %{})),
          delete(conn, Routes.user_path(conn, :delete, "123")),
          get(conn, Routes.client_path(conn, :index)),
          get(conn, Routes.client_path(conn, :show, "123")),
          put(conn, Routes.client_path(conn, :update, "123", %{})),
          delete(conn, Routes.client_path(conn, :delete, "123"))
        ],
        fn conn ->
          assert json_response(conn, 401)
        end
      )
    end
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      {_, _, token} = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> get(Routes.user_path(conn, :index))

      [reg | _data] = json_response(conn, 200)["data"]
      assert %{"uid" => _uid} = reg
    end
  end
end
