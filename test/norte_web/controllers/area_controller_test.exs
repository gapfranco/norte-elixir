defmodule NorteWeb.AreaControllerTest do
  use NorteWeb.ConnCase

  alias Norte.Accounts
  alias Norte.Password

  alias Norte.Areas
  alias Norte.Areas.Area
  # alias Norte.Accounts.User

  @create_attrs %{
    key: "cod",
    name: "some name"
  }
  @create_sub_attrs %{
    key: "cod.1",
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{key: "", name: nil}

  @valid_client_attrs %{
    cid: "tst",
    name: "Teste",
    uid: "usr@tst",
    username: "test-user",
    email: "teste@example.com",
    password: "secret",
    password_confirmation: "secret"
  }

  def fixture(:area) do
    {:ok, area} = Areas.create_area(@create_attrs)
    area
  end

  def client_fixture(attrs \\ %{}) do
    {:ok, %{client: _client, user: _user}} =
      attrs
      |> Enum.into(@valid_client_attrs)
      |> Accounts.create_client()

    # user = Map.put(user, :password, nil)
    {:ok, token, _claims} = Password.token_sign_in("usr@tst", "secret")
    token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all areas", %{conn: conn} do
      token = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> get(Routes.area_path(conn, :index))

      assert json_response(conn, 200)["list"] == []
    end
  end

  describe "create area" do
    test "renders area when data is valid", %{conn: conn} do
      token = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post(Routes.area_path(conn, :create), area: @create_attrs)

      assert %{"id" => id, "client_id" => client_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.area_path(conn, :show, id))

      assert %{
               "id" => id,
               "key" => "cod",
               "name" => "some name",
               "client_id" => client_id
             } = json_response(conn, 200)["data"]
    end

    test "renders error when subkey with no key", %{conn: conn} do
      token = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post(Routes.area_path(conn, :create), area: @create_sub_attrs)

      assert conn.status == 400
    end

    test "renders errors when data is invalid", %{conn: conn} do
      token = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post(Routes.area_path(conn, :create), area: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update area" do
    setup [:create_area]

    test "renders area when data is valid", %{conn: conn, area: %Area{id: id} = area} do
      token = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> put(Routes.area_path(conn, :update, area), area: @update_attrs)

      # conn = put(conn, Routes.unit_path(conn, :update, unit), unit: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
      conn = get(conn, Routes.area_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, area: area} do
      token = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> put(Routes.area_path(conn, :update, area), area: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete area" do
    setup [:create_area]

    test "deletes chosen area", %{conn: conn, area: area} do
      token = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> delete(Routes.area_path(conn, :delete, area))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.area_path(conn, :show, area))
      end
    end
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.area_path(conn, :index)),
        get(conn, Routes.area_path(conn, :show, "123")),
        put(conn, Routes.area_path(conn, :update, "123", %{})),
        post(conn, Routes.area_path(conn, :create, %{})),
        delete(conn, Routes.area_path(conn, :delete, "123"))
      ],
      fn conn ->
        assert json_response(conn, 401)
      end
    )
  end

  defp create_area(_) do
    area = fixture(:area)
    {:ok, area: area}
  end
end
