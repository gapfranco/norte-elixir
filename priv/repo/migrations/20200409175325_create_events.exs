defmodule Norte.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :event_date, :date
      add :key, :string
      add :name, :string
      add :text, :string
      add :uid, :string
      add :unit_key, :string
      add :unit_id, references(:units, on_delete: :restrict)
      add :area_id, references(:areas, on_delete: :restrict)
      add :risk_id, references(:risks, on_delete: :restrict)
      add :process_id, references(:processes, on_delete: :restrict)
      add :user_id, references(:users, on_delete: :nothing)
      add :client_id, references(:clients, on_delete: :nothing)

      timestamps()
    end

    create index(:events, [:unit_id])
    create index(:events, [:area_id])
    create index(:events, [:risk_id])
    create index(:events, [:process_id])
    create index(:events, [:user_id])
    create index(:events, [:client_id])
  end
end
