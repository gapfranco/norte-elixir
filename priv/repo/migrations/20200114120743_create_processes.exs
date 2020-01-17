defmodule Norte.Repo.Migrations.CreateProcesses do
  use Ecto.Migration

  def change do
    create table(:processes) do
      add :key, :string
      add :name, :string
      add :up_id, references(:processes, on_delete: :delete_all)
      add :client_id, references(:clients, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:processes, [:key])
    create index(:processes, [:up_id])
    create index(:processes, [:client_id])
  end
end
