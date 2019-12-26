defmodule Norte.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :cid, :string
      add :name, :string
      add :code, :string
      add :term, :utc_datetime
      add :val_user, :decimal
      add :val_unit, :decimal
      add :status, :integer

      timestamps()
    end

    create unique_index(:clients, [:cid])
  end
end
