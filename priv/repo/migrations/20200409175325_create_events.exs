defmodule Norte.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :event_date, :date
      add :text, :string, size: 4000
      add :uid, :string
      add :unit_key, :string
      add :unit_name, :string
      add :item_key, :string
      add :item_name, :string
      add :item_text, :string
      add :area_key, :string
      add :area_name, :string
      add :risk_key, :string
      add :risk_name, :string
      add :process_key, :string
      add :process_name, :string
      add :user_id, references(:users, on_delete: :restrict)
      add :client_id, references(:clients, on_delete: :restrict)

      timestamps()
    end

    create index(:events, [:user_id])
    create index(:events, [:client_id])
  end
end
