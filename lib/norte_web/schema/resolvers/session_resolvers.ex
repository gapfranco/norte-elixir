defmodule NorteWeb.Schema.Resolvers.SessionResolvers do
  alias Norte.Password

  def login_user(_, %{input: input}, _) do
    Password.token_signin(input)
  end
end
