defmodule NorteWeb.Schema.Resolvers.UserResolvers do
  alias Norte.Accounts

  def list_users(_, args, %{context: context}) do
    {:ok, Accounts.list_users(context.current_user.client_id, args)}
  end

  def get_user_uid(_, %{uid: uid}, %{context: context}) do
    {:ok, Accounts.get_user_uid(uid, context.current_user.client_id)}
  end

  def list_clients(_, args, _) do
    {:ok, Accounts.list_clients(args)}
  end

  def get_client_cid(_, %{cid: cid}, _) do
    {:ok, Accounts.get_client_cid(cid)}
  end
end
