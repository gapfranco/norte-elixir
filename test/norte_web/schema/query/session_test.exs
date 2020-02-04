defmodule Norte.Schema.Query.SessionTest do
  use NorteWeb.ConnCase, async: true
  alias Norte.Password

  setup do
    Norte.Seeds.run()
  end

  @user %{uid: "usr@cl1", password: "secret"}

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

  test "user can signin with uid and password" do
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
