defmodule Ocular.EventsTest do
  use Ocular.DataCase

  alias Ocular.Events

  describe "events" do
    alias Ocular.Events.Event

    import Ocular.EventsFixtures

    @invalid_attrs %{
      event_leader: nil,
      item_power: nil,
      join_command: nil,
      location: nil,
      name: nil,
      objective: nil,
      tier: nil,
      time: nil,
      type: nil
    }

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        event_leader: "some event_leader",
        item_power: 42,
        join_command: "some join_command",
        location: "some location",
        name: "some name",
        objective: "some objective",
        tier: 42,
        time: ~U[2024-09-27 15:04:00Z],
        type: "some type"
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.event_leader == "some event_leader"
      assert event.item_power == 42
      assert event.join_command == "some join_command"
      assert event.location == "some location"
      assert event.name == "some name"
      assert event.objective == "some objective"
      assert event.tier == 42
      assert event.time == ~U[2024-09-27 15:04:00Z]
      assert event.type == "some type"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        event_leader: "some updated event_leader",
        item_power: 43,
        join_command: "some updated join_command",
        location: "some updated location",
        name: "some updated name",
        objective: "some updated objective",
        tier: 43,
        time: ~U[2024-09-28 15:04:00Z],
        type: "some updated type"
      }

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.event_leader == "some updated event_leader"
      assert event.item_power == 43
      assert event.join_command == "some updated join_command"
      assert event.location == "some updated location"
      assert event.name == "some updated name"
      assert event.objective == "some updated objective"
      assert event.tier == 43
      assert event.time == ~U[2024-09-28 15:04:00Z]
      assert event.type == "some updated type"
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

  describe "builds" do
    alias Ocular.Events.Build

    import Ocular.EventsFixtures

    @invalid_attrs %{
      cape: nil,
      chest: nil,
      feet: nil,
      food: nil,
      head: nil,
      offhand: nil,
      pot: nil,
      weapon: nil
    }

    test "list_builds/0 returns all builds" do
      build = build_fixture()
      assert Events.list_builds() == [build]
    end

    test "get_build!/1 returns the build with given id" do
      build = build_fixture()
      assert Events.get_build!(build.id) == build
    end

    test "create_build/1 with valid data creates a build" do
      valid_attrs = %{
        cape: "some cape",
        chest: "some chest",
        feet: "some feet",
        food: "some food",
        head: "some head",
        offhand: "some offhand",
        pot: "some pot",
        weapon: "some weapon"
      }

      assert {:ok, %Build{} = build} = Events.create_build(valid_attrs)
      assert build.cape == "some cape"
      assert build.chest == "some chest"
      assert build.feet == "some feet"
      assert build.food == "some food"
      assert build.head == "some head"
      assert build.offhand == "some offhand"
      assert build.pot == "some pot"
      assert build.weapon == "some weapon"
    end

    test "create_build/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_build(@invalid_attrs)
    end

    test "update_build/2 with valid data updates the build" do
      build = build_fixture()

      update_attrs = %{
        cape: "some updated cape",
        chest: "some updated chest",
        feet: "some updated feet",
        food: "some updated food",
        head: "some updated head",
        offhand: "some updated offhand",
        pot: "some updated pot",
        weapon: "some updated weapon"
      }

      assert {:ok, %Build{} = build} = Events.update_build(build, update_attrs)
      assert build.cape == "some updated cape"
      assert build.chest == "some updated chest"
      assert build.feet == "some updated feet"
      assert build.food == "some updated food"
      assert build.head == "some updated head"
      assert build.offhand == "some updated offhand"
      assert build.pot == "some updated pot"
      assert build.weapon == "some updated weapon"
    end

    test "update_build/2 with invalid data returns error changeset" do
      build = build_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_build(build, @invalid_attrs)
      assert build == Events.get_build!(build.id)
    end

    test "delete_build/1 deletes the build" do
      build = build_fixture()
      assert {:ok, %Build{}} = Events.delete_build(build)
      assert_raise Ecto.NoResultsError, fn -> Events.get_build!(build.id) end
    end

    test "change_build/1 returns a build changeset" do
      build = build_fixture()
      assert %Ecto.Changeset{} = Events.change_build(build)
    end
  end
end
