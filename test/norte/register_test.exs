defmodule Norte.RegisterTest do
  use Norte.DataCase

  alias Norte.Accounts
  alias Norte.Accounts.User

  describe "register_user/1" do
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

    test "with invalid data does not insert user" do
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

    test "requires user uid to be at least 3 chars long" do
      attrs = Map.put(@valid_attrs, :uid, "A")
      assert {:error, _, changeset, _} = Accounts.create_client(attrs)

      assert %{uid: ["should be at least 3 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end

    test "requires user name to at most 200 chars long" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("x", 201))
      assert {:error, _, changeset, _} = Accounts.create_client(attrs)

      assert %{username: ["should be at most 200 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end
  end
end
