defmodule Norte.Repo.Migrations.AddRatingAlert do
  use Ecto.Migration

  def change do
    alter table(:ratings) do
      add(:alert_user_id, references(:users))
    end

    create(index(:ratings, [:alert_user_id]))
  end
end
