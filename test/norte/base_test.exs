defmodule Norte.BaseTest do
  use Norte.DataCase

  alias Norte.Base

  describe "units" do
    alias Norte.Base.Unit

    @valid_attrs %{key: "cod", name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{key: nil, name: nil}

    def unit_fixture(attrs \\ %{}) do
      {:ok, unit} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Base.create_unit()

      unit
    end

    test "list_units/0 returns all units" do
      unit = unit_fixture()
      assert Base.list_units() == [unit]
    end

    test "get_unit!/1 returns the unit with given id" do
      unit = unit_fixture()
      assert Base.get_unit!(unit.id) == unit
    end

    test "create_unit/1 with valid data creates a unit" do
      assert {:ok, %Unit{} = unit} = Base.create_unit(@valid_attrs)
      assert unit.key == "cod"
      assert unit.name == "some name"
    end

    test "create_unit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Base.create_unit(@invalid_attrs)
    end

    test "update_unit/2 with valid data updates the unit" do
      unit = unit_fixture()
      assert {:ok, %Unit{} = unit} = Base.update_unit(unit, @update_attrs)
      assert unit.name == "some updated name"
    end

    test "update_unit/2 with invalid data returns error changeset" do
      unit = unit_fixture()
      assert {:error, %Ecto.Changeset{}} = Base.update_unit(unit, @invalid_attrs)
      assert unit == Base.get_unit!(unit.id)
    end

    test "delete_unit/1 deletes the unit" do
      unit = unit_fixture()
      assert {:ok, %Unit{}} = Base.delete_unit(unit)
      assert_raise Ecto.NoResultsError, fn -> Base.get_unit!(unit.id) end
    end

    test "change_unit/1 returns a unit changeset" do
      unit = unit_fixture()
      assert %Ecto.Changeset{} = Base.change_unit(unit)
    end
  end
end
