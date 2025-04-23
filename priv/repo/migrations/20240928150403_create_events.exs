defmodule Ocular.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :item_power, :integer
      add :tier, :integer
      add :objective, :string
      add :time, :string
      add :location, :string
      add :caller, :string
      add :quality, :string
      add :regeared?, :boolean

      timestamps(type: :utc_datetime)
    end
  end
end
