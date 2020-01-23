defmodule Norte.Password do
  import Pbkdf2

  alias Norte.Guardian
  alias Norte.Accounts.User
  alias Norte.Repo

  def hash(password) do
    hash_pwd_salt(password)
  end

  def verify_with_hash(password, hash), do: verify_pass(password, hash)

  def dummy_verify, do: no_user_verify()

  def token_signin(input) do
    with {:ok, user} <- uid_password_auth(input.uid, input.password),
         {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt_token, user: user}}
    end
  end

  def token_sign_in(uid, password) do
    case uid_password_auth(uid, password) do
      {:ok, user} ->
        Guardian.encode_and_sign(user)

      _ ->
        {:error, :unauthorized}
    end
  end

  defp uid_password_auth(uid, password) when is_binary(uid) and is_binary(password) do
    with {:ok, user} <- get_by_uid(uid),
         do: verify_password(password, user)
  end

  defp get_by_uid(uid) when is_binary(uid) do
    case Repo.get_by(User, uid: uid) do
      nil ->
        dummy_verify()
        {:error, :login_error}

      user ->
        if user.expired || user.block do
          {:error, :blocked}
        else
          {:ok, user}
        end
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if verify_with_hash(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :login_error}
    end
  end
end
