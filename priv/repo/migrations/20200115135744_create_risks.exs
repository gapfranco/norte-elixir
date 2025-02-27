defmodule Norte.Repo.Migrations.CreateRisks do
  use Ecto.Migration

  def change do
    create table(:risks) do
      add :key, :string
      add :name, :string
      add :up_id, references(:risks, on_delete: :delete_all)
      add :client_id, references(:clients, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:risks, [:client_id, :key], name: :risks_key_index)
    create index(:risks, [:up_id])
  end
end
