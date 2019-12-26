defmodule Norte.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :string
      add :username, :string
      add :email, :string
      add :password_hash, :string
      add :expired, :boolean, default: false, null: false
      add :admin, :boolean, default: false, null: false
      add :block, :boolean, default: false, null: false
      add :token, :string
      add :token_date, :utc_datetime

      timestamps()
    end

    create unique_index(:users, [:uid])
  end
end
