defmodule Ocular.Repo.Migrations.ChangeEventTime do
  use Ecto.Migration

  alias Ocular.Repo

  def change do
    Repo.delete_all(Ocular.Events.Event)

    alter table(:events) do
      remove :time
    end

    flush()

    alter table(:events) do
      add :time, :naive_datetime
    end
  end
end
