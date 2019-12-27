defmodule Norte.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Norte.Password

  schema "users" do
    field :admin, :boolean, default: false
    field :block, :boolean, default: false
    field :email, :string
    field :expired, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string
    field :token, :string
    field :token_date, :utc_datetime
    field :uid, :string
    field :username, :string
    belongs_to(:client, Norte.Accounts.Client)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:uid, :username, :email, :client_id, :token, :token_date, :expired, :block])
    |> validate_required([:uid, :username, :email, :client_id, :password_hash])
    |> validate_length(:uid, min: 3, max: 20)
    |> validate_length(:username, min: 3, max: 200)
    |> unique_constraint(:uid)
  end

  def changeset_with_password(user, params \\ %{}) do
    user
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, required: true)
    |> hash_password()
    |> changeset(params)
  end

  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:password_hash, Password.hash(password))
  end

  defp hash_password(changeset), do: changeset
end
