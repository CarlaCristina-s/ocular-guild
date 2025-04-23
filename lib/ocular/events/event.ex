defmodule Ocular.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :caller, :string
    field :item_power, :integer
    field :quality, :string
    field :location, :string
    field :name, :string
    field :objective, :string
    field :tier, :integer
    field :time, :naive_datetime
    field :regeared?, :boolean

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :name,
      :regeared?,
      :tier,
      :item_power,
      :time,
      :location,
      :objective,
      :quality,
      :caller
    ])
    |> validate_required([
      :name,
      :regeared?,
      :tier,
      :item_power,
      :time,
      :location,
      :objective,
      :quality,
      :caller
    ])
  end
end
