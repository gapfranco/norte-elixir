defmodule NorteWeb.Schema.Resolvers.RatingResolvers do
  alias Norte.Ratings
  alias NorteWeb.Schema.Middleware.ChangesetErrors

  def list_ratings(_, args, %{context: context}) do
    {:ok, Ratings.list_ratings(args.user_id, context.current_user.client_id, args)}
  end

  def get_rating(_, %{id: id}, %{context: context}) do
    {:ok, Ratings.get_rating(id, context.current_user.client_id)}
  end

  def create_rating(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)

    case Ratings.create_rating(args) do
      {:error, changeset} ->
        {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

      {:ok, unit} ->
        {:ok, unit}
    end
  end

  def update_rating(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)
    rating = Ratings.get_rating(args.id, context.current_user.client_id)

    if rating === nil do
      {:error, "Invalid id"}
    else
      case Ratings.update_rating(rating, args) do
        {:error, changeset} ->
          {:error, message: "Update error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, item} ->
          {:ok, item}
      end
    end
  end

  def delete_rating(_, args, %{context: context}) do
    rating = Ratings.get_rating(args.id, context.current_user.client_id)

    if rating === nil do
      {:error, "Invalid id"}
    else
      case Ratings.delete_rating(rating) do
        {:error, changeset} ->
          {:error, message: "Delete error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, item} ->
          {:ok, item}
      end
    end
  end
end