defmodule Norte.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo

  alias Norte.Events.Event
  alias Norte.Items
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

    Pagination.paginate(query, criteria, :date_due, &filter_with_all/2)
  end

  defp filter_with_all(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where:
            ilike(q.name, ^pattern) or
              ilike(q.uid, ^pattern) or
              ilike(q.key, ^pattern) or
              ilike(q.unit_key, ^pattern)

        # or
        #   ilike(q.key, ^pattern)
    end)
  end

  def list_ratings(user_id, client_id, criteria) do
    query =
      from a in Event,
        order_by: [desc: a.event_date, desc: a.id],
        where: a.client_id == ^client_id and a.user_id == ^user_id

    Pagination.paginate(query, criteria, :date_due, &filter_with/2)
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
    item = Items.get_item(rating.item_id)

    attrs = %{
      event_date: rating.date_ok,
      key: rating.item_key,
      name: item.name,
      unit_key: rating.unit_key,
      text: rating.notes,
      uid: rating.uid,
      unit_id: rating.unit_id,
      user_id: rating.user_id,
      area_id: rating.area_id,
      risk_id: rating.risk_id,
      process_id: rating.process_id,
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
end
