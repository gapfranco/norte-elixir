defmodule Norte.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :date_due, :date
      add :date_ok, :date
      add :result, :string
      add :notes, :string
      add :item_id, references(:items, on_delete: :restrict)
      add :unit_id, references(:units, on_delete: :restrict)
      add :user_id, references(:users, on_delete: :restrict)
      add :area_id, references(:areas, on_delete: :restrict)
      add :risk_id, references(:risks, on_delete: :restrict)
      add :process_id, references(:processes, on_delete: :restrict)
      add :client_id, references(:clients, on_delete: :restrict)

      timestamps()
    end

    create index(:ratings, [:client_id, :user_id, :date_due, :unit_id, :item_id],
             name: :ratings_user_index
           )

    create unique_index(:ratings, [:item_id, :unit_id, :date_due], name: :ratings_units_index)

    create index(:ratings, [:item_id])
    create index(:ratings, [:unit_id])
    create index(:ratings, [:user_id])
    create index(:ratings, [:area_id])
    create index(:ratings, [:risk_id])
    create index(:ratings, [:process_id])
    create index(:ratings, [:client_id])
  end
end
