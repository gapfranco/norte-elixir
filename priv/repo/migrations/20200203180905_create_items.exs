defmodule Norte.Repo.Migrations.CreateItens do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :key, :string
      add :name, :string
      add :text, :string
      add :base, :date
      add :freq, :string
      add :area_id, references(:areas, on_delete: :restrict)
      add :risk_id, references(:risks, on_delete: :restrict)
      add :process_id, references(:processes, on_delete: :restrict)
      add :up_id, references(:items, on_delete: :delete_all)
      add :client_id, references(:clients, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:items, [:client_id, :key], name: :items_key_index)
    create index(:items, [:area_id])
    create index(:items, [:risk_id])
    create index(:items, [:process_id])
    create index(:items, [:up_id])
  end
end
