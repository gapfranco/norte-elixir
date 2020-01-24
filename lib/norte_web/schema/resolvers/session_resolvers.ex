defmodule NorteWeb.Schema.Resolvers.SessionResolvers do
  alias Norte.Password
  alias Norte.Accounts
  alias NorteWeb.Schema.Middleware.ChangesetErrors

  def login_user(_, %{input: input}, _) do
    Password.token_signin(input)
  end

  def signup_user(_, %{input: input}, _) do
    case Accounts.create_client(input) do
      {:ok, %{client: client, user: user}} ->
        {:ok,
         %{
           cid: client.cid,
           name: client.name,
           uid: user.uid,
           username: user.username,
           email: user.email
         }}

      {:error, :client, changeset, _} ->
        {:error, ChangesetErrors.transform_errors(changeset)}

      {:error, :user, changeset, _} ->
        {:error, ChangesetErrors.transform_errors(changeset)}
    end
  end
end
