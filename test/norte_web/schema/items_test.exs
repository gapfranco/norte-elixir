defmodule Norte.Schema.Query.ItemsTest do
  use NorteWeb.ConnCase, async: true
  alias Norte.Password

  setup do
    Norte.Seeds.run()
  end

  @user %{uid: "usr@cl1", password: "secret"}

  @valid_attrs %{
    key: "03",
    name: "test"
  }

  @invalid_attrs %{
    key: "04.01",
    name: "test"
  }

  def conn_user(conn) do
    {:ok, %{token: token, user: _}} = Password.token_signin(@user)
    conn |> put_req_header("authorization", "Bearer #{token}")
  end

  @create """
  mutation($key: String!, $name: String!) {
    itemCreate (key: $key, name: $name) {
      key
      name
      client {
        cid
      }
    }
  }
  """

  @update """
  mutation($key: String!, $name: String!) {
    itemUpdate (key: $key, name: $name) {
      key
      name
    }
  }
  """

  @delete """
  mutation($key: String!) {
    itemDelete (key: $key) {
      key
    }
  }
  """

  @list """
  query {
    items {
      list {
        key
      }
    }
  }
  """

  describe "items maintenance" do
    test "cannot create item unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{"itemCreate" => nil},
               "errors" => [
                 %{
                   "locations" => [
                     %{
                       "column" => 0,
                       "line" => 2
                     }
                   ],
                   "message" => "unauthorized",
                   "path" => [
                     "itemCreate"
                   ]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot create with invalid key" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @create, variables: @invalid_attrs)

      assert %{
               "data" => %{"itemCreate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["itemCreate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "create a new item in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{
                 "itemCreate" => %{
                   "key" => "03",
                   "name" => "test",
                   "client" => %{
                     "cid" => "cl1"
                   }
                 }
               }
             } == json_response(conn, 200)
    end

    test "list items only of current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{
                 "items" => %{
                   "list" => [
                     %{"key" => "01"},
                     %{"key" => "02"}
                   ]
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot list items unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{"items" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["items"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "update a item in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{
                 "itemUpdate" => %{
                   "key" => "01",
                   "name" => "alterado"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot update items of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "011", "name" => "alterado"}
        )

      assert %{
               "data" => %{"itemUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["itemUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot update items when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{"itemUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["itemUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "delete a item in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{
                 "itemDelete" => %{
                   "key" => "01"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot delete items of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "011"}
        )

      assert %{
               "data" => %{"itemDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["itemDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot delete items when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{"itemDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["itemDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end
  end
end
