defmodule Norte.ItemsTest do
  use Norte.DataCase

  alias Norte.Items

  describe "itens" do
    alias Norte.Items.Item

    @valid_attrs %{base: ~D[2010-04-17], key: "some key", name: "some name", period: 42, text: "some text"}
    @update_attrs %{base: ~D[2011-05-18], key: "some updated key", name: "some updated name", period: 43, text: "some updated text"}
    @invalid_attrs %{base: nil, key: nil, name: nil, period: nil, text: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Items.create_item()

      item
    end

    test "list_itens/0 returns all itens" do
      item = item_fixture()
      assert Items.list_itens() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Items.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Items.create_item(@valid_attrs)
      assert item.base == ~D[2010-04-17]
      assert item.key == "some key"
      assert item.name == "some name"
      assert item.period == 42
      assert item.text == "some text"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Items.update_item(item, @update_attrs)
      assert item.base == ~D[2011-05-18]
      assert item.key == "some updated key"
      assert item.name == "some updated name"
      assert item.period == 43
      assert item.text == "some updated text"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Items.update_item(item, @invalid_attrs)
      assert item == Items.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Items.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Items.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Items.change_item(item)
    end
  end
end
