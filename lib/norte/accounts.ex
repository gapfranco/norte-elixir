defmodule Norte.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo
  alias Ecto.Multi
  alias Norte.Pagination

  alias Norte.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def list_users(client_id) do
    q = from u in User, where: u.client_id == ^client_id
    Repo.all(q)
  end

  def list_users_page(params) do
    q = from u in User, order_by: u.uid
    Pagination.list_query(q, params)
  end

  def list_users_page(client_id, params) do
    q = from u in User, where: u.client_id == ^client_id, order_by: u.uid
    Pagination.list_query(q, params)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user(id, client_id) do
    q = from u in User, where: u.id == ^id, where: u.client_id == ^client_id
    Repo.one(q)
  end

  def get_user_uid(uid) do
    q = from u in User, where: u.uid == ^uid
    Repo.one(q)
  end

  def get_user_uid(uid, client_id) do
    q = from u in User, where: u.uid == ^uid, where: u.client_id == ^client_id
    Repo.one(q)
  end

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

  def update_user_with_password(%User{} = user, attrs) do
    user
    |> User.changeset_with_password(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def delete_user(%User{} = user, client_id) do
    if user.client_id == client_id do
      Repo.delete(user)
    end
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Norte.Accounts.Client

  def list_clients do
    Repo.all(Client)
  end

  def get_client!(id), do: Repo.get!(Client, id)
  def get_client(id), do: Repo.get(Client, id)

  def get_user_client(%User{} = user) do
    get_client(user.id)
  end

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

  # Dataloader

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  # def query(Booking, %{scope: :place, limit: limit}) do
  #   Booking
  #   |> where(state: "reserved")
  #   |> order_by([desc: :start_date])
  #   |> limit(^limit)
  # end

  # def query(Booking, %{scope: :user}) do
  #   Booking
  #   |> order_by([asc: :start_date])
  # end

  def query(queryable, _) do
    queryable
  end
end
