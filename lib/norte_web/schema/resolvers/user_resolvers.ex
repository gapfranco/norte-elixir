defmodule NorteWeb.Schema.Resolvers.UserResolvers do
  alias Norte.Accounts
  alias NorteWeb.Schema.Middleware.ChangesetErrors

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

  def create_user(_, args, %{context: context}) do
    args =
      args
      |> Map.put(:client_id, context.current_user.client_id)
      |> Map.put(:uid, "#{args.uid}@#{context.current_user.client.cid}")
      |> Map.put(:password, "expired_password")
      |> Map.put(:password_confirmation, "expired_password")
      |> Map.put(:expired, true)

    case Accounts.create_user(args) do
      {:error, changeset} ->
        {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

      {:ok, unit} ->
        {:ok, unit}
    end
  end

  def update_user(_, args, %{context: context}) do
    user = Accounts.get_user_uid(args.uid, context.current_user.client_id)

    if user === nil do
      {:error, "Invalid id"}
    else
      case Accounts.update_user(user, args) do
        {:error, changeset} ->
          {:error, message: "Update error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, unit} ->
          {:ok, unit}
      end
    end
  end

  def delete_user(_, args, %{context: context}) do
    user = Accounts.get_user_uid(args.uid, context.current_user.client_id)

    if user === nil do
      {:error, "Invalid id"}
    else
      case Accounts.delete_user(user) do
        {:error, changeset} ->
          {:error, message: "Delete error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, unit} ->
          {:ok, unit}
      end
    end
  end
end
