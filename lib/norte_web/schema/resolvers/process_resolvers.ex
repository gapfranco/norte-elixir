defmodule NorteWeb.Schema.Resolvers.ProcessResolvers do
  alias Norte.Processes
  alias NorteWeb.Schema.Middleware.ChangesetErrors

  def list_processes(_, args, %{context: context}) do
    {:ok, Processes.list_processes(context.current_user.client_id, args)}
  end

  def get_process(_, %{key: key}, %{context: context}) do
    {:ok, Processes.get_process_by_key(key, context.current_user.client_id)}
  end

  def create_process(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)
    pts = String.split(args.key, ".")

    if length(pts) > 1 do
      {_, arr} = List.pop_at(pts, -1)

      sup =
        Enum.join(arr, ".")
        |> Processes.get_process_by_key(context.current_user.client_id)

      if sup === nil do
        {:error, "Invalid key"}
      else
        args = Map.put(args, :up_id, sup.id)

        case Processes.create_process(args) do
          {:error, changeset} ->
            {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

          {:ok, unit} ->
            {:ok, unit}
        end
      end
    else
      case Processes.create_process(args) do
        {:error, changeset} ->
          {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, unit} ->
          {:ok, unit}
      end
    end
  end

  def update_process(_, args, %{context: context}) do
    process = Processes.get_process_by_key(args.key, context.current_user.client_id)

    if process === nil do
      {:error, "Invalid key"}
    else
      case Processes.update_process(process, args) do
        {:error, changeset} ->
          {:error, message: "Update error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, process} ->
          {:ok, process}
      end
    end
  end

  def delete_process(_, args, %{context: context}) do
    process = Processes.get_process_by_key(args.key, context.current_user.client_id)

    if process === nil do
      {:error, "Invalid key"}
    else
      case Processes.delete_process(process) do
        {:error, changeset} ->
          {:error, message: "Delete error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, process} ->
          {:ok, process}
      end
    end
  end
end
