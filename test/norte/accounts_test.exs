defmodule Norte.AccountsTest do
  use Norte.DataCase

  alias Norte.Accounts
  alias Norte.Accounts.User

  describe "client" do
    @valid_attrs %{
      cid: "tst",
      name: "Teste",
      uid: "usr@tst",
      username: "test-user",
      email: "teste@example.com",
      password: "secret",
      password_confirmation: "secret"
    }
    @invalid_attrs %{}

    test "with valid data insert client and user" do
      assert {:ok, %{client: client, user: %User{id: id} = user}} =
               Accounts.create_client(@valid_attrs)

      assert client.cid == "tst"
      assert client.name == "Teste"
      assert user.uid == "usr@tst"
      assert user.username == "test-user"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data does not insert client and user" do
      assert {:error, _, _, _} = Accounts.create_client(@invalid_attrs)
      assert Accounts.list_users() == []
    end

    test "enforces unique client cid" do
      assert {:ok, %{client: client, user: %User{id: id} = user}} =
               Accounts.create_client(@valid_attrs)

      assert {:error, _, changeset, _} = Accounts.create_client(@valid_attrs)
      assert %{cid: ["has already been taken"]} = errors_on(changeset)
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "requires password to be at least 6 chars long" do
      attrs = Map.put(@valid_attrs, :password, "12345")
      assert {:error, _, changeset, _} = Accounts.create_client(attrs)

      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end

    test "requires client cid to be at least 3 chars long" do
      attrs = Map.put(@valid_attrs, :cid, "A")
      assert {:error, _, changeset, _} = Accounts.create_client(attrs)

      assert %{cid: ["should be at least 3 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end

    test "requires client name to at most 200 chars long" do
      attrs = Map.put(@valid_attrs, :name, String.duplicate("x", 201))
      assert {:error, _, changeset, _} = Accounts.create_client(attrs)

      assert %{name: ["should be at most 200 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end

    test "requires client user uid to be at least 3 chars long" do
      attrs = Map.put(@valid_attrs, :uid, "A")
      assert {:error, _, changeset, _} = Accounts.create_client(attrs)

      assert %{uid: ["should be at least 3 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end

    test "requires client user name to at most 200 chars long" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("x", 201))
      assert {:error, _, changeset, _} = Accounts.create_client(attrs)

      assert %{username: ["should be at most 200 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end
  end

  describe "users" do
    alias Norte.Accounts.User

    @valid_attrs %{
      cid: "tst",
      name: "Teste",
      uid: "usr@tst",
      username: "test-user",
      email: "teste@example.com",
      password: "secret",
      password_confirmation: "secret"
    }
    @valid_user_attrs %{
      admin: false,
      block: false,
      email: "mais@example.com",
      expired: true,
      uid: "uid2",
      username: "username2",
      password: "secret",
      password_confirmation: "secret"
    }
    @update_user_attrs %{
      admin: true,
      block: true,
      email: "outro@example.com",
      expired: false,
      uid: "uid2",
      username: "username2"
    }
    @invalid_user_attrs %{
      email: nil,
      uid: nil,
      username: nil
    }

    def client_fixture(attrs \\ %{}) do
      {:ok, %{client: client, user: user}} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_client()

      user = Map.put(user, :password, nil)
      {client, user}
    end

    test "list_users/0 returns all users" do
      {_, user} = client_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user/1 returns the user with given id" do
      {_, user} = client_fixture()
      assert Accounts.get_user(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      {client, _} = client_fixture()

      create_attrs = Enum.into(%{client_id: client.id}, @valid_user_attrs)
      assert {:ok, %User{} = user} = Accounts.create_user(create_attrs)
      assert user.uid == "uid2"
      assert user.admin == false
      assert user.block == false
      assert user.email == "mais@example.com"
      assert user.expired == true
      assert user.username == "username2"
      assert user.client_id == client.id
    end

    test "update_user/2 with valid data updates the user" do
      {_, user} = client_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_user_attrs)
      assert user.admin == true
      assert user.block == true
      assert user.email == "outro@example.com"
      assert user.expired == false
      assert user.uid == "uid2"
      assert user.username == "username2"
    end

    test "update_user/2 with invalid data returns error changeset" do
      {_, user} = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_user_attrs)
      assert user == Accounts.get_user(user.id)
    end

    test "delete_user/1 deletes the user" do
      {_, user} = client_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end
end
