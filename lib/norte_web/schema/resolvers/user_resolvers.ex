defmodule NorteWeb.Schema.Resolvers.UserResolvers do
  alias Norte.Accounts

  def list_users(_, _, _) do
    {:ok, Accounts.list_users()}
  end
end
