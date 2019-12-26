defmodule Norte.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo
  alias Ecto.Multi

  alias Norte.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset_with_password(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Norte.Accounts.Client

  def list_clients do
    Repo.all(Client)
  end

  def get_client!(id), do: Repo.get!(Client, id)
  def get_client(id), do: Repo.get!(Client, id)

  def new_client, do: Client.changeset(%Client{})

  def insert_client(params) do
    Multi.new()
    |> Multi.insert(:client, Client.changeset(%Client{}, params))
    |> Multi.insert(:user, fn %{client: %Client{id: client_id}} ->
      User.changeset_with_password(%User{client_id: client_id}, params)
    end)
    |> Repo.transaction()
    |> IO.inspect()
  end

  def create_client(attrs) do
    Multi.new()
    |> Multi.insert(:client, Client.changeset(%Client{}, attrs))
    |> Multi.insert(:user, fn %{client: %Client{id: client_id}} ->
      User.changeset_with_password(%User{client_id: client_id}, attrs)
    end)
    |> Repo.transaction()
    |> IO.inspect()
  end

  def update_client(%Client{} = client, attrs) do
    client
    |> Client.changeset(attrs)
    |> Repo.update()
  end

  def delete_client(%Client{} = client) do
    Repo.delete(client)
  end

  def change_client(%Client{} = client) do
    Client.changeset(client, %{})
  end
end
