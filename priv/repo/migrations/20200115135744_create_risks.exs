defmodule Norte.Repo.Migrations.CreateRisks do
  use Ecto.Migration

  def change do
    create table(:risks) do
      add :key, :string
      add :name, :string
      add :up_id, references(:areas, on_delete: :nothing)
      add :client_id, references(:clients, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:risks, [:key])
    create index(:risks, [:up_id])
    create index(:risks, [:client_id])
  end
end
