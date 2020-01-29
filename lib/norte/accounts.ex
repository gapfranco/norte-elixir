defmodule Norte.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo
  alias Ecto.Multi
  alias Norte.Pagination

  alias Norte.Accounts.User

  def list_users(client_id, criteria) do
    query = from u in User, where: u.client_id == ^client_id
    Pagination.paginate(query, criteria, :uid, &filter_with/2)
  end

  defp filter_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where:
            ilike(q.username, ^pattern) or
              ilike(q.uid, ^pattern) or
              ilike(q.email, ^pattern)
    end)
  end

  def list_users do
    Repo.all(User)
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

  def list_clients(criteria) do
    query = from(u in Client)
    Pagination.paginate(query, criteria, :cid, &filter_client_with/2)
  end

  defp filter_client_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where: ilike(q.name, ^pattern)
    end)
  end

  def get_client!(id), do: Repo.get!(Client, id)
  def get_client(id), do: Repo.get(Client, id)

  def get_client_cid(cid) do
    q = from c in Client, where: c.cid == ^cid
    Repo.one(q)
  end

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

  def query(queryable, _) do
    queryable
  end
end
