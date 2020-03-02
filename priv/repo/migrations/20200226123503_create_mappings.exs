defmodule Norte.Repo.Migrations.CreateMappings do
  use Ecto.Migration

  def change do
    create table(:mappings) do
      add :item_id, references(:items, on_delete: :delete_all)
      add :unit_id, references(:units, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :client_id, references(:clients, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:mappings, [:item_id, :unit_id], name: :mappings_units_index)
    create index(:mappings, [:item_id])
    create index(:mappings, [:unit_id])
    create index(:mappings, [:user_id])
    create index(:mappings, [:client_id])
  end
end
