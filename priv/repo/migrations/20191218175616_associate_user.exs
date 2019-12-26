defmodule Norte.Repo.Migrations.AssociateUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:client_id, references(:clients))
    end

    create(index(:users, [:client_id]))
  end
end
