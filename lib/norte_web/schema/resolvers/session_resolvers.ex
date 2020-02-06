defmodule NorteWeb.Schema.Resolvers.SessionResolvers do
  alias Norte.Password
  alias Norte.Accounts
  alias NorteWeb.Schema.Middleware.ChangesetErrors
  alias Norte.{Email, Mailer}

  def login_user(_, %{input: input}, _) do
    Password.token_signin(input)
  end

  def signup_user(_, %{input: input}, _) do
    input = %{input | uid: "#{input[:uid]}@#{input[:cid]}"}

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

  def create_password(_, %{input: input}, _) do
    user = Accounts.get_user_uid(input.uid)
    IO.inspect(input)

    if user == nil do
      {:error, "Usuário inválido"}
    else
      date = DateTime.utc_now()

      if user.token == input.token and user.token_date >= date do
        case Accounts.update_user_with_password(user, %{
               password: input.password,
               password_confirmation: input.password_confirmation,
               expired: false,
               token: nil,
               token_date: nil
             }) do
          {:ok, _} ->
            {:ok, %{msg: "Password created"}}

          {:error, changeset} ->
            {:error, ChangesetErrors.transform_errors(changeset)}
        end
      else
        {:error, "Invalid token"}
      end
    end
  end

  def change_password(
        _,
        %{
          old_password: old_password,
          password: password,
          password_confirmation: password_confirmation
        },
        %{context: context}
      ) do
    user = Accounts.get_user_uid(context.current_user.uid, context.current_user.client_id)

    case Password.verify_password(old_password, %Accounts.User{} = user) do
      {:error, :login_error} ->
        {:error, "Senha atual inválida"}

      {:ok, _} ->
        if user == nil do
          {:error, "Usuário inválido"}
        else
          case Accounts.update_user_with_password(user, %{
                 password: password,
                 password_confirmation: password_confirmation,
                 expired: false,
                 token: nil,
                 token_date: nil
               }) do
            {:ok, _} ->
              {:ok, %{msg: "Password changed"}}

            {:error, changeset} ->
              {:error, ChangesetErrors.transform_errors(changeset)}
          end
        end
    end
  end

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end
end
