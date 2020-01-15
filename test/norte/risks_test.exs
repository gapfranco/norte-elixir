defmodule Norte.RisksTest do
  use Norte.DataCase

  alias Norte.Risks

  describe "risks" do
    alias Norte.Risks.Risk

    @valid_attrs %{key: "cod", name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{key: nil, name: nil}

    def risk_fixture(attrs \\ %{}) do
      {:ok, risk} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Risks.create_risk()

      risk
    end

    test "list_risks/0 returns all risks" do
      risk = risk_fixture()
      assert Risks.list_risks() == [risk]
    end

    test "get_risk!/1 returns the risk with given id" do
      risk = risk_fixture()
      assert Risks.get_risk!(risk.id) == risk
    end

    test "create_risk/1 with valid data creates a risk" do
      assert {:ok, %Risk{} = risk} = Risks.create_risk(@valid_attrs)
      assert risk.key == "cod"
      assert risk.name == "some name"
    end

    test "create_risk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Risks.create_risk(@invalid_attrs)
    end

    test "update_risk/2 with valid data updates the risk" do
      risk = risk_fixture()
      assert {:ok, %Risk{} = risk} = Risks.update_risk(risk, @update_attrs)
      assert risk.name == "some updated name"
    end

    test "update_risk/2 with invalid data returns error changeset" do
      risk = risk_fixture()
      assert {:error, %Ecto.Changeset{}} = Risks.update_risk(risk, @invalid_attrs)
      assert risk == Risks.get_risk!(risk.id)
    end

    test "delete_risk/1 deletes the risk" do
      risk = risk_fixture()
      assert {:ok, %Risk{}} = Risks.delete_risk(risk)
      assert_raise Ecto.NoResultsError, fn -> Risks.get_risk!(risk.id) end
    end

    test "change_risk/1 returns a risk changeset" do
      risk = risk_fixture()
      assert %Ecto.Changeset{} = Risks.change_risk(risk)
    end
  end
end
