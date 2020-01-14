defmodule Norte.Processes do
  @moduledoc """
  The Processes context.
  """

  import Ecto.Query, warn: false
  alias Norte.Repo

  alias Norte.Processes.Process
  alias Norte.Pagination

  def list_processes do
    q = from p in Process, order_by: p.key
    Repo.all(q)
  end

  def list_processes_page(params) do
    q = from p in Process, order_by: p.key
    Pagination.list_query(q, params)
  end

  def get_process!(id), do: Repo.get!(Process, id)

  def get_process(id), do: Repo.get(Process, id)

  def get_process_by_key(key) do
    q = from p in Process, where: p.key == ^key
    Repo.one(q)
  end

  def create_process(attrs \\ %{}) do
    %Process{}
    |> Process.changeset(attrs)
    |> Repo.insert()
  end

  def update_process(%Process{} = process, attrs) do
    process
    |> Process.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_process(%Process{} = process) do
    Repo.delete(process)
  end

  def change_process(%Process{} = process) do
    Process.update_changeset(process, %{})
  end
end
