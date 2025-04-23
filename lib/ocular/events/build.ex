defmodule Ocular.Events.Build do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ocular.Accounts.Player
  alias Ocular.Events.Event

  schema "builds" do
    field :cape, :string
    field :chest, :string
    field :feet, :string
    field :food, :string
    field :head, :string
    field :offhand, :string
    field :pot, :string
    field :weapon, :string
    belongs_to :event, Event
    belongs_to :player, Player

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(build, attrs) do
    build
    |> cast(attrs, [
      :weapon,
      :offhand,
      :head,
      :chest,
      :feet,
      :cape,
      :food,
      :pot,
      :event_id,
      :player_id
    ])
    |> validate_required([:weapon, :head, :chest, :feet, :cape, :food, :pot, :event_id])
  end
end
