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
        order_by: [a.unit_key, desc: a.date_due, desc: a.id],
        where: a.client_id == ^client_id and not is_nil(a.result)

    Pagination.paginate(query, criteria, :date_due, &filter_with_all/2)
  end

  defp filter_with_all(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where:
            ilike(q.uid, ^pattern) or
              ilike(q.item_key, ^pattern) or
              ilike(q.item_name, ^pattern) or
              ilike(q.unit_key, ^pattern) or
              ilike(q.unit_name, ^pattern) or
              ilike(q.risk_key, ^pattern) or
              ilike(q.area_key, ^pattern) or
              ilike(q.process_key, ^pattern) or
              ilike(q.risk_name, ^pattern) or
              ilike(q.area_name, ^pattern) or
              ilike(q.process_name, ^pattern)

        # or
        #   ilike(q.key, ^pattern)
    end)
  end

  def list_ratings(user_id, client_id, criteria) do
    query =
      from a in Rating,
        order_by: [desc: a.date_due, desc: a.id],
        where: a.client_id == ^client_id and a.user_id == ^user_id

    Pagination.paginate(query, criteria, :date_due, &filter_with_all/2)
  end

  # defp filter_with(_filters, query) do
  #   query
  # end

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
      |> Map.put(:item_name, item.name)
      |> Map.put(:item_text, item.text)
      |> Map.put(:unit_key, unit.key)
      |> Map.put(:unit_name, unit.name)
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

  def report_ratings(client_id, criteria) do
    query =
      from a in Rating,
        order_by: [a.item_key, a.unit_key, a.date_due],
        where: a.client_id == ^client_id

    Enum.reduce(criteria, query, fn
      {:date_ini, date_ini}, query ->
        from q in query,
          where: q.date_due >= ^date_ini

      {:date_end, date_end}, query ->
        from q in query,
          where: q.date_due <= ^date_end

      {:item, item}, query ->
        from q in query,
          where: q.item_key == ^item

      {:unit, unit}, query ->
        from q in query,
          where: q.unit_key == ^unit

      {:user, user}, query ->
        from q in query,
          where: q.uid == ^user

      {:area, area}, query ->
        from q in query,
          where: q.area_key == ^area

      {:risk, risk}, query ->
        from q in query,
          where: q.risk_key == ^risk

      {:process, process}, query ->
        from q in query,
          where: q.process_key == ^process
    end)
    |> Repo.all()
  end

  # Dataloader

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
