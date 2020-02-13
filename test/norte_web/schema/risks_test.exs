defmodule Norte.Schema.Query.RisksTest do
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
    riskCreate (key: $key, name: $name) {
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
    riskUpdate (key: $key, name: $name) {
      key
      name
    }
  }
  """

  @delete """
  mutation($key: String!) {
    riskDelete (key: $key) {
      key
    }
  }
  """

  @list """
  query {
    risks {
      list {
        key
      }
    }
  }
  """

  describe "risks maintenance" do
    test "cannot create risk unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{"riskCreate" => nil},
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
                     "riskCreate"
                   ]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "create a new risk in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{
                 "riskCreate" => %{
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
               "data" => %{"riskCreate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["riskCreate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "list risks only of current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{
                 "risks" => %{
                   "list" => [
                     %{"key" => "01"},
                     %{"key" => "02"}
                   ]
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot list risks unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{"risks" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["risks"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "update a risk in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{
                 "riskUpdate" => %{
                   "key" => "01",
                   "name" => "alterado"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot update risks of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "011", "name" => "alterado"}
        )

      assert %{
               "data" => %{"riskUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["riskUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot update risks when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @update,
          variables: %{"key" => "01", "name" => "alterado"}
        )

      assert %{
               "data" => %{"riskUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["riskUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "delete a risk in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{
                 "riskDelete" => %{
                   "key" => "01"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot delete risks of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "011"}
        )

      assert %{
               "data" => %{"riskDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid key",
                   "path" => ["riskDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot delete risks when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @delete,
          variables: %{"key" => "01"}
        )

      assert %{
               "data" => %{"riskDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["riskDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end
  end
end
