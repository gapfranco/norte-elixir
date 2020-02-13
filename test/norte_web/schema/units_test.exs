defmodule Norte.Schema.Query.UnitsTest do
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

  def conn_user(conn) do
    {:ok, %{token: token, user: _}} = Password.token_signin(@user)
    conn |> put_req_header("authorization", "Bearer #{token}")
  end

  @create """
  mutation($key: String!, $name: String!) {
    unitCreate (key: $key, name: $name) {
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
    unitUpdate (key: $key, name: $name) {
      key
      name
    }
  }
  """

  @delete """
  mutation($key: String!) {
    unitDelete (key: $key) {
      key
    }
  }
  """

  @list """
  query {
    units {
      list {
        key
      }
    }
  }
  """

  describe "units maintenance" do
    test "cannot create unit unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{"unitCreate" => nil},
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
                     "unitCreate"
                   ]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "create a new unit in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{
                 "unitCreate" => %{
                   "key" => "03",
                   "name" => "test",
                   "client" => %{
                     "cid" => "cl1"
                   }
                 }
               }
             } == json_response(conn, 200)
    end

    test "list units only of current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{
                 "units" => %{
                   "list" => [
                     %{"key" => "01"},
                     %{"key" => "02"}
                   ]
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot list units unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{"units" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["units"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "update a unit in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{
                 "unitUpdate" => %{
                   "key" => "01",
                   "name" => "alterado"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot update units of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "011", "name" => "alterado"}
        )

      assert %{
               "data" => %{"unitUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["unitUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot update units when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{"unitUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["unitUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "delete a unit in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{
                 "unitDelete" => %{
                   "key" => "01"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot delete units of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "011"}
        )

      assert %{
               "data" => %{"unitDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["unitDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot delete units when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{"unitDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["unitDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end
  end
end
