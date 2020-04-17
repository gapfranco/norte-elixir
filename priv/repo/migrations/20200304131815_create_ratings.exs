defmodule Norte.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :date_due, :date
      add :date_ok, :date
      add :result, :string
      add :notes, :string, size: 4000
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

    # create index(:ratings, [:client_id, :user_id, :date_due, :unit_id, :item_id],
    #          name: :ratings_user_index
    #        )
    create unique_index(:ratings, [:item_key, :unit_key, :date_due], name: :ratings_units_index)
    create index(:ratings, [:user_id])
    create index(:ratings, [:client_id])
  end
end
