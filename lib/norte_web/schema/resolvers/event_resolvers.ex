defmodule NorteWeb.Schema.Resolvers.EventResolvers do
  alias Norte.Events
  alias NorteWeb.Schema.Middleware.ChangesetErrors

  def list_events(_, args, %{context: context}) do
    {:ok, Events.list_events(context.current_user.id, context.current_user.client_id, args)}
  end

  def list_all_events(_, args, %{context: context}) do
    {:ok, Events.list_events(context.current_user.client_id, args)}
  end

  def get_event(_, %{id: id}, %{context: context}) do
    {:ok, Events.get_event(id, context.current_user.client_id)}
  end

  def create_event(_, args, %{context: context}) do
    rating_id = args.rating_id

    case Events.create_event_rating(rating_id, context.current_user.client_id) do
      {:error, changeset} ->
        {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

      {:ok, event} ->
        {:ok, event}
    end
  end

  def update_event(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)
    rating = Events.get_event(args.id, context.current_user.client_id)

    if rating === nil do
      {:error, "Invalid id"}
    else
      case Events.update_event(rating, args) do
        {:error, changeset} ->
          {:error, message: "Update error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, item} ->
          {:ok, item}
      end
    end
  end

  def delete_event(_, args, %{context: context}) do
    rating = Events.get_event(args.id, context.current_user.client_id)

    if rating === nil do
      {:error, "Invalid id"}
    else
      case Events.delete_event(rating) do
        {:error, changeset} ->
          {:error, message: "Delete error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, item} ->
          {:ok, item}
      end
    end
  end
end
