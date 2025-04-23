defmodule Ocular.Repo.Migrations.CreateBuilds do
  use Ecto.Migration

  def change do
    create table(:builds) do
      add :weapon, :string
      add :offhand, :string
      add :head, :string
      add :chest, :string
      add :feet, :string
      add :cape, :string
      add :food, :string
      add :pot, :string
      add :event_id, references(:events, on_delete: :delete_all)
      add :player_id, references(:players, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
