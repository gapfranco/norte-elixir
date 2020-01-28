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

    create unique_index(:processes, [:client_id, :key], name: :processes_key_index)
    create index(:processes, [:up_id])
  end
end
