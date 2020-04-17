defmodule Norte.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo

  alias Norte.Events.Event
  alias Norte.Pagination
  alias Norte.Ratings

  def list_events do
    Repo.all(Event)
  end

  def list_events(client_id, criteria) do
    query =
      from a in Event,
        order_by: [desc: a.event_date, desc: a.id],
        where: a.client_id == ^client_id

    Pagination.paginate(query, criteria, :event_date, &filter_with_all/2)
  end

  defp filter_with_all(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where:
            ilike(q.name, ^pattern) or
              ilike(q.uid, ^pattern) or
              ilike(q.item_key, ^pattern) or
              ilike(q.unit_key, ^pattern)

        # or
        #   ilike(q.key, ^pattern)
    end)
  end

  def list_events(user_id, client_id, criteria) do
    query =
      from a in Event,
        order_by: [desc: a.event_date, desc: a.id],
        where: a.client_id == ^client_id and a.user_id == ^user_id

    Pagination.paginate(query, criteria, :event_date, &filter_with/2)
  end

  defp filter_with(_filters, query) do
    query
  end

  def get_event(id, client_id) do
    q = from a in Event, where: a.id == ^id and a.client_id == ^client_id
    Repo.one(q)
  end

  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def create_event_rating(rating_id, client_id) do
    rating = Ratings.get_rating(rating_id, client_id)

    # item = Items.get_item(rating.item_id)

    attrs = %{
      event_date: rating.date_ok,
      item_key: rating.item_key,
      item_name: rating.item_name,
      text: rating.notes,
      uid: rating.uid,
      unit_key: rating.unit_key,
      unit_name: rating.unit_name,
      area_key: rating.area_key,
      area_name: rating.area_name,
      risk_key: rating.risk_key,
      risk_name: rating.risk_name,
      process_key: rating.process_key,
      process_name: rating.process_name,
      user_id: rating.user_id,
      client_id: client_id
    }

    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  # Dataloader

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
