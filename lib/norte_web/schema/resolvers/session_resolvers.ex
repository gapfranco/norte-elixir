defmodule NorteWeb.Schema.Resolvers.SessionResolvers do
  alias Norte.Password
  alias Norte.Accounts
  alias NorteWeb.Schema.Middleware.ChangesetErrors
  alias Norte.{Email, Mailer}

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

  def forgot_password(_, %{uid: uid}, _) do
    user = Accounts.get_user_uid(uid)

    if user == nil do
      {:error, "Usuário inválido"}
    else
      client = Accounts.get_client(user.client_id)

      token =
        :crypto.strong_rand_bytes(10)
        |> Base.url_encode64()
        |> binary_part(0, 10)
        |> String.downcase()

      date = DateTime.utc_now() |> DateTime.add(2 * 60 * 60 * 24)
      Accounts.update_user(user, %{token: token, token_date: date})
      Email.forgot_password_email(user.email, user.uid, client.cid, token) |> Mailer.deliver_now()
      {:ok, %{msg: "E-Mail enviado"}}
    end
  end
end
