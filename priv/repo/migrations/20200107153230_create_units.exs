defmodule Norte.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :key, :string
      add :name, :string
      add :up_id, references(:units, on_delete: :delete_all)
      add :client_id, references(:clients, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:units, [:key])
    create index(:units, [:up_id])
    create index(:units, [:client_id])
  end
end
