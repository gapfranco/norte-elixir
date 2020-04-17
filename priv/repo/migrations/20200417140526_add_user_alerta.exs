defmodule Norte.Repo.Migrations.AddUserAlerta do
  use Ecto.Migration

  def change do
    alter table(:mappings) do
      add(:alert_user_id, references(:users))
    end

    create(index(:mappings, [:alert_user_id]))
  end
end
