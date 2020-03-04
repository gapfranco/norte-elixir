defmodule Norte.Ratings do
  @moduledoc """
  The Ratings context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo

  alias Norte.Ratings.Rating
  alias Norte.Pagination

  def list_ratings do
    Repo.all(Rating)
  end

  def list_ratings(client_id, user_id, criteria) do
    query = from a in Rating, where: a.client_id == ^client_id and a.user_id == ^user_id
    Pagination.paginate(query, criteria, :date_due, &filter_with/2)
  end

  defp filter_with(_filters, query) do
    query
  end

  def get_rating(id, client_id) do
    q = from a in Rating, where: a.id == ^id and a.client_id == ^client_id
    Repo.one(q)
  end

  def create_rating(attrs \\ %{}) do
    %Rating{}
    |> Rating.changeset(attrs)
    |> Repo.insert()
  end

  def update_rating(%Rating{} = rating, attrs) do
    rating
    |> Rating.changeset(attrs)
    |> Repo.update()
  end

  def delete_rating(%Rating{} = rating) do
    Repo.delete(rating)
  end

  def change_rating(%Rating{} = rating) do
    Rating.changeset(rating, %{})
  end

  # Dataloader

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
