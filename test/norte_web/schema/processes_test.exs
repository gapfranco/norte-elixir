defmodule Norte.Schema.Query.ProcessesTest do
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
    processCreate (key: $key, name: $name) {
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
    processUpdate (key: $key, name: $name) {
      key
      name
    }
  }
  """

  @delete """
  mutation($key: String!) {
    processDelete (key: $key) {
      key
    }
  }
  """

  @list """
  query {
    processes {
      list {
        key
      }
    }
  }
  """

  describe "processes maintenance" do
    test "cannot create process unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{"processCreate" => nil},
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
                     "processCreate"
                   ]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "create a new process in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{
                 "processCreate" => %{
                   "key" => "03",
                   "name" => "test",
                   "client" => %{
                     "cid" => "cl1"
                   }
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot create with invalid key" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @create, variables: @invalid_attrs)

      assert %{
               "data" => %{"processCreate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["processCreate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "list processes only of current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{
                 "processes" => %{
                   "list" => [
                     %{"key" => "01"},
                     %{"key" => "02"}
                   ]
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot list processes unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{"processes" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["processes"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "update a process in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{
                 "processUpdate" => %{
                   "key" => "01",
                   "name" => "alterado"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot update processes of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "011", "name" => "alterado"}
        )

      assert %{
               "data" => %{"processUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["processUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot update processes when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{"processUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["processUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "delete a process in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{
                 "processDelete" => %{
                   "key" => "01"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot delete processes of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "011"}
        )

      assert %{
               "data" => %{"processDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["processDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot delete processes when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{"processDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["processDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end
  end
end
