defmodule Norte.EventsTest do
  use Norte.DataCase

  alias Norte.Events

  describe "events" do
    alias Norte.Events.Event

    @valid_attrs %{area_id: "some area_id", area_name: "some area_name", date_event: ~D[2010-04-17], key: "some key", name: "some name", notes: "some notes", process_key: "some process_key", process_name: "some process_name", risk_key: "some risk_key", risk_name: "some risk_name", text: "some text", uid: "some uid", unit_key: "some unit_key", unit_name: "some unit_name"}
    @update_attrs %{area_id: "some updated area_id", area_name: "some updated area_name", date_event: ~D[2011-05-18], key: "some updated key", name: "some updated name", notes: "some updated notes", process_key: "some updated process_key", process_name: "some updated process_name", risk_key: "some updated risk_key", risk_name: "some updated risk_name", text: "some updated text", uid: "some updated uid", unit_key: "some updated unit_key", unit_name: "some updated unit_name"}
    @invalid_attrs %{area_id: nil, area_name: nil, date_event: nil, key: nil, name: nil, notes: nil, process_key: nil, process_name: nil, risk_key: nil, risk_name: nil, text: nil, uid: nil, unit_key: nil, unit_name: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.area_id == "some area_id"
      assert event.area_name == "some area_name"
      assert event.date_event == ~D[2010-04-17]
      assert event.key == "some key"
      assert event.name == "some name"
      assert event.notes == "some notes"
      assert event.process_key == "some process_key"
      assert event.process_name == "some process_name"
      assert event.risk_key == "some risk_key"
      assert event.risk_name == "some risk_name"
      assert event.text == "some text"
      assert event.uid == "some uid"
      assert event.unit_key == "some unit_key"
      assert event.unit_name == "some unit_name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.area_id == "some updated area_id"
      assert event.area_name == "some updated area_name"
      assert event.date_event == ~D[2011-05-18]
      assert event.key == "some updated key"
      assert event.name == "some updated name"
      assert event.notes == "some updated notes"
      assert event.process_key == "some updated process_key"
      assert event.process_name == "some updated process_name"
      assert event.risk_key == "some updated risk_key"
      assert event.risk_name == "some updated risk_name"
      assert event.text == "some updated text"
      assert event.uid == "some updated uid"
      assert event.unit_key == "some updated unit_key"
      assert event.unit_name == "some updated unit_name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
