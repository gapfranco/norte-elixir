defmodule Norte.Ratings do
  @moduledoc """
  The Ratings context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo

  alias Norte.Ratings.Rating
  alias Norte.Items
  alias Norte.Pagination
  alias Norte.Base
  alias Norte.Accounts

  def list_ratings do
    Repo.all(Rating)
  end

  # %{filter: %{matching: "unidatexxx"}, limit: 10, order: :asc, page: 1}
  def list_ratings(client_id, criteria) do
    query =
      from a in Rating,
        order_by: [a.unit_id, desc: a.date_due, desc: a.id],
        where: a.client_id == ^client_id and not is_nil(a.result)

    Pagination.paginate(query, criteria, :date_due, &filter_with_all/2)
  end

  defp filter_with_all(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where:
            ilike(q.result, ^pattern) or
              ilike(q.uid, ^pattern) or
              ilike(q.item_key, ^pattern) or
              ilike(q.unit_key, ^pattern)

        # or
        #   ilike(q.key, ^pattern)
    end)
  end

  def list_ratings(user_id, client_id, criteria) do
    query =
      from a in Rating,
        order_by: [desc: a.date_due, desc: a.id],
        where: a.client_id == ^client_id and a.user_id == ^user_id

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
    item = Items.get_item(attrs.item_id)
    unit = Base.get_unit(attrs.unit_id)
    user = Accounts.get_user(attrs.user_id)

    attrs =
      attrs
      |> Map.put(:area_id, item.area_id)
      |> Map.put(:risk_id, item.risk_id)
      |> Map.put(:process_id, item.process_id)
      |> Map.put(:item_key, item.key)
      |> Map.put(:unit_key, unit.key)
      |> Map.put(:uid, user.uid)

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
