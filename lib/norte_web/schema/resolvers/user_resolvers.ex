defmodule NorteWeb.Schema.Resolvers.UserResolvers do
  alias Norte.Accounts

  def list_users(_, _, %{context: context}) do
    {:ok, Accounts.list_users(context.current_user.client_id)}
  end
end
