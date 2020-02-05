defmodule Norte.Schema.Query.UsersTest do
  use NorteWeb.ConnCase, async: true
  alias Norte.Password

  setup do
    Norte.Seeds.run()
  end

  @user %{uid: "usr@cl1", password: "secret"}

  @valid_attrs %{
    uid: "test",
    username: "test-user",
    email: "teste@example.com"
  }

  def conn_user(conn) do
    {:ok, %{token: token, user: _}} = Password.token_signin(@user)
    conn |> put_req_header("authorization", "Bearer #{token}")
  end

  @create """
  mutation($uid: String!, $email: String!, $username: String!) {
    userCreate (uid: $uid, email: $email, username: $username) {
      uid
      client {
        cid
      }
    }
  }
  """

  @update """
  mutation($uid: String!, $username: String!) {
    userUpdate (uid: $uid, username: $username) {
      uid
      username
    }
  }
  """

  @delete """
  mutation($uid: String!) {
    userDelete (uid: $uid) {
      uid
    }
  }
  """

  @list """
  query {
    users {
      list {
        uid
      }
    }
  }
  """

  describe "users maintenance" do
    test "cannot create user unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{"userCreate" => nil},
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
                     "userCreate"
                   ]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "create a new user in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @create, variables: @valid_attrs)

      assert %{
               "data" => %{
                 "userCreate" => %{
                   "uid" => "test@cl1",
                   "client" => %{
                     "cid" => "cl1"
                   }
                 }
               }
             } == json_response(conn, 200)
    end

    test "list users only of current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{
                 "users" => %{
                   "list" => [
                     %{"uid" => "usr@cl1"}
                   ]
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot list users unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql", query: @list)

      assert %{
               "data" => %{"users" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["users"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "update a user in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"uid" => "usr@cl1", "username" => "alterado"}
        )

      assert %{
               "data" => %{
                 "userUpdate" => %{
                   "uid" => "usr@cl1",
                   "username" => "alterado"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot update users of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @update,
          variables: %{"uid" => "usr@cl2", "username" => "alterado"}
        )

      assert %{
               "data" => %{"userUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid id",
                   "path" => ["userUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot update users when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @update,
          variables: %{"uid" => "usr@cl1", "username" => "alterado"}
        )

      assert %{
               "data" => %{"userUpdate" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["userUpdate"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "delete a user in current client" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"uid" => "usr@cl1"}
        )

      assert %{
               "data" => %{
                 "userDelete" => %{
                   "uid" => "usr@cl1"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot delete users of other clients" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql",
          query: @delete,
          variables: %{"uid" => "usr@cl2"}
        )

      assert %{
               "data" => %{"userDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "Invalid id",
                   "path" => ["userDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "cannot delete users when unauthenticated" do
      conn =
        build_conn()
        |> post("/graphql",
          query: @delete,
          variables: %{"uid" => "usr@cl1"}
        )

      assert %{
               "data" => %{"userDelete" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "unauthorized",
                   "path" => ["userDelete"]
                 }
               ]
             } == json_response(conn, 200)
    end
  end
end
