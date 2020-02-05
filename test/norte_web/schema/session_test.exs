defmodule Norte.Schema.Query.SessionTest do
  use NorteWeb.ConnCase, async: true
  alias Norte.Password

  setup do
    Norte.Seeds.run()
  end

  @user %{uid: "usr@cl1", password: "secret"}

  @invalid_user %{uid: "usr@cl1", password: "invalid"}

  @valid_attrs %{
    cid: "tst",
    name: "Teste",
    uid: "usr@tst",
    username: "test-user",
    email: "teste@example.com",
    password: "secret",
    password_confirmation: "secret"
  }
  @invalid_attrs %{
    cid: "cl1",
    name: "Teste",
    uid: "usr@tst",
    username: "test-user",
    email: "teste@example.com",
    password: "secret",
    password_confirmation: "secret"
  }

  def conn_user(conn) do
    {:ok, %{token: token, user: _}} = Password.token_signin(@user)
    conn |> put_req_header("authorization", "Bearer #{token}")
  end

  @signin """
  mutation($input: SessionInputType!) {
    signin (input: $input) {
      user {
        uid
      }
    }
  }
  """

  @signup """
  mutation($input: SignupInputType!) {
    signup (input: $input) {
      cid
      name
      uid
      email
      username
    }
  }
  """

  @me """
  query {
    me {
      uid
      username
      client {
        cid
        name
      }
    }
  }
  """

  describe "authentication" do
    test "sign-up new client and user whith valid data" do
      conn =
        build_conn()
        |> post("/graphql", query: @signup, variables: %{"input" => @valid_attrs})

      assert %{
               "data" => %{
                 "signup" => %{
                   "cid" => "tst",
                   "name" => "Teste",
                   "uid" => "usr@tst",
                   "email" => "teste@example.com",
                   "username" => "test-user"
                 }
               }
             } == json_response(conn, 200)
    end

    test "cannot sign-up duplicate client and user whith valid data" do
      conn =
        build_conn()
        |> post("/graphql", query: @signup, variables: %{"input" => @invalid_attrs})

      assert %{
               "data" => %{"signup" => nil},
               "errors" => [
                 %{
                   "key" => "cid",
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => ["has already been taken"],
                   "path" => ["signup"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "user can signin with valid credentials" do
      conn =
        build_conn()
        |> post("/graphql", query: @signin, variables: %{"input" => @user})

      assert %{
               "data" => %{
                 "signin" => %{
                   "user" => %{
                     "uid" => "usr@cl1"
                   }
                 }
               }
             } == json_response(conn, 200)
    end

    test "user cannot signin with invalid credentials" do
      conn =
        build_conn()
        |> post("/graphql", query: @signin, variables: %{"input" => @invalid_user})

      assert %{
               "data" => %{"signin" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" => "login_error",
                   "path" => ["signin"]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "me query returns current user" do
      conn =
        build_conn()
        |> conn_user()
        |> post("/graphql", query: @me)

      assert %{
               "data" => %{
                 "me" => %{
                   "uid" => "usr@cl1",
                   "username" => "Person 1.1",
                   "client" => %{
                     "cid" => "cl1",
                     "name" => "Client 1"
                   }
                 }
               }
             } == json_response(conn, 200)
    end

    test "me query fails if not signed in" do
      conn =
        build_conn()
        |> get("/graphql", query: @me)

      assert %{
               "me" => nil
             } == json_response(conn, 200)["data"]
    end
  end
end
