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

    create unique_index(:units, [:client_id, :key], name: :units_key_index)
    create index(:units, [:up_id])
  end
end
