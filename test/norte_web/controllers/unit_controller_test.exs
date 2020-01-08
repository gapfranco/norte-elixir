defmodule NorteWeb.UnitControllerTest do
  use NorteWeb.ConnCase

  alias Norte.Accounts
  alias Norte.Password

  alias Norte.Base
  alias Norte.Base.Unit

  @create_attrs %{
    key: "cod",
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

  def fixture(:unit) do
    {:ok, unit} = Base.create_unit(@create_attrs)
    unit
  end

  def client_fixture(attrs \\ %{}) do
    {:ok, %{client: client, user: user}} =
      attrs
      |> Enum.into(@valid_client_attrs)
      |> Accounts.create_client()

    user = Map.put(user, :password, nil)
    {:ok, token, _claims} = Password.token_sign_in("usr@tst", "secret")
    {client, user, token}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all units", %{conn: conn} do
      {_, _, token} = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> get(Routes.unit_path(conn, :index))

      json_response(conn, 200)["data"] == []
    end
  end

  describe "create unit" do
    test "renders unit when data is valid", %{conn: conn} do
      {_, _, token} = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post(Routes.unit_path(conn, :create), unit: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.unit_path(conn, :show, id))

      assert %{
               "id" => id,
               "key" => "cod",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {_, _, token} = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> post(Routes.unit_path(conn, :create), unit: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update unit" do
    setup [:create_unit]

    test "renders unit when data is valid", %{conn: conn, unit: %Unit{id: id} = unit} do
      {_, _, token} = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> put(Routes.unit_path(conn, :update, unit), unit: @update_attrs)

      # conn = put(conn, Routes.unit_path(conn, :update, unit), unit: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
      conn = get(conn, Routes.unit_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, unit: unit} do
      {_, _, token} = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> put(Routes.unit_path(conn, :update, unit), unit: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete unit" do
    setup [:create_unit]

    test "deletes chosen unit", %{conn: conn, unit: unit} do
      {_, _, token} = client_fixture()

      conn =
        conn
        |> put_req_header("authorization", "bearer: " <> token)
        |> delete(Routes.unit_path(conn, :delete, unit))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.unit_path(conn, :show, unit))
      end
    end
  end

  defp create_unit(_) do
    unit = fixture(:unit)
    {:ok, unit: unit}
  end
end
