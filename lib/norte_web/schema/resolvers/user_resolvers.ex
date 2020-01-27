defmodule NorteWeb.Schema.Resolvers.UserResolvers do
  alias Norte.Accounts

  def list_users(_, args, %{context: context}) do
    {:ok, Accounts.list_users(context.current_user.client_id, args)}
  end

  def list_clients(_, args, _) do
    {:ok, Accounts.list_clients(args)}
  end
end
