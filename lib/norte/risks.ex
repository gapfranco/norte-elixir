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

  def list_risks_page(params) do
    q = from r in Risk, order_by: r.key
    Pagination.list_query(q, params)
  end

  def get_risk!(id), do: Repo.get!(Risk, id)

  def get_risk(id), do: Repo.get(Risk, id)

  def get_risk_by_key(key) do
    q = from r in Risk, where: r.key == ^key
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
end
