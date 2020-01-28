defmodule Norte.Repo.Migrations.CreateAreas do
  use Ecto.Migration

  def change do
    create table(:areas) do
      add :key, :string
      add :name, :string
      add :up_id, references(:areas, on_delete: :delete_all)
      add :client_id, references(:clients, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:areas, [:client_id, :key], name: :areas_key_index)
    create index(:areas, [:up_id])
  end
end
