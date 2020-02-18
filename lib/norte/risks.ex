defmodule Norte.Risks do
  @moduledoc """
  The Risks context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo

  alias Norte.Risks.Risk
  alias Norte.Pagination

  def list_risks do
    q = from r in Risk, order_by: r.key
    Repo.all(q)
  end

  def list_risks(client_id, criteria) do
    query = from r in Risk, where: r.client_id == ^client_id
    Pagination.paginate(query, criteria, :key, &filter_with/2)
  end

  defp filter_with(filters, query) do
    Enum.reduce(filters, query, fn
      {:matching, term}, query ->
        pattern = "%#{term}%"

        from q in query,
          where:
            ilike(q.name, ^pattern) or
              ilike(q.key, ^pattern)
    end)
  end

  def list_risks_page(params) do
    q = from r in Risk, order_by: r.key
    Pagination.list_query(q, params)
  end

  def get_risk!(id), do: Repo.get!(Risk, id)

  def get_risk(id), do: Repo.get(Risk, id)

  def get_risk_by_key(key, client_id) do
    q = from r in Risk, where: r.key == ^key and r.client_id == ^client_id
    Repo.one(q)
  end

  def create_risk(attrs \\ %{}) do
    %Risk{}
    |> Risk.changeset(attrs)
    |> Repo.insert()
  end

  def update_risk(%Risk{} = risk, attrs) do
    risk
    |> Risk.changeset(attrs)
    |> Repo.update()
  end

  def delete_risk(%Risk{} = risk) do
    Repo.delete(risk)
  end

  def change_risk(%Risk{} = risk) do
    Risk.changeset(risk, %{})
  end

  # Dataloader

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
