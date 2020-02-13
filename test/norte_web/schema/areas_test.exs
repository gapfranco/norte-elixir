defmodule Norte.Schema.Query.AreasTest do
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
    areaCreate (key: $key, name: $name) {
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
    areaUpdate (key: $key, name: $name) {
      key
      name
    }
  }
  """

  @delete """
  mutation($key: String!) {
    areaDelete (key: $key) {
      key
    }
  }
  """

  @list """
  query {
    areas {
      list {
        key
      }
    }
  }
  """

  describe "areas maintenance" do
    test "cannot create area unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{"areaCreate" => nil},
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
                     "areaCreate"
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
               "data" => %{"areaCreate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["areaCreate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "create a new area in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{
                 "areaCreate" => %{
                   "key" => "03",
                   "name" => "test",
                   "client" => %{
                     "cid" => "cl1"
                   }
                 }
               }
             } == json_response(conn, 200)
    end

    test "list areas only of current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{
                 "areas" => %{
                   "list" => [
                     %{"key" => "01"},
                     %{"key" => "02"}
                   ]
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot list areas unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{"areas" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["areas"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "update a area in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{
                 "areaUpdate" => %{
                   "key" => "01",
                   "name" => "alterado"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot update areas of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "011", "name" => "alterado"}
        )

      assert %{
               "data" => %{"areaUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["areaUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot update areas when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{"areaUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["areaUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "delete a area in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{
                 "areaDelete" => %{
                   "key" => "01"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot delete areas of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "011"}
        )

      assert %{
               "data" => %{"areaDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["areaDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot delete areas when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{"areaDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["areaDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end
  end
end
