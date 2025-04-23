defmodule Ocular.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ocular.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        event_leader: "some event_leader",
        item_power: 42,
        join_command: "some join_command",
        location: "some location",
        name: "some name",
        objective: "some objective",
        tier: 42,
        time: ~U[2024-09-27 15:04:00Z],
        type: "some type"
      })
      |> Ocular.Events.create_event()

    event
  end

  @doc """
  Generate a build.
  """
  def build_fixture(attrs \\ %{}) do
    {:ok, build} =
      attrs
      |> Enum.into(%{
        cape: "some cape",
        chest: "some chest",
        feet: "some feet",
        food: "some food",
        head: "some head",
        offhand: "some offhand",
        pot: "some pot",
        weapon: "some weapon"
      })
      |> Ocular.Events.create_build()

    build
  end
end
