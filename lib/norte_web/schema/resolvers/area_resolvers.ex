defmodule NorteWeb.Schema.Resolvers.AreaResolvers do
  alias Norte.Areas
  alias NorteWeb.Schema.Middleware.ChangesetErrors

  def list_areas(_, args, %{context: context}) do
    {:ok, Areas.list_areas(context.current_user.client_id, args)}
  end

  def get_area(_, %{key: key}, %{context: context}) do
    {:ok, Areas.get_area_by_key(key, context.current_user.client_id)}
  end

  def create_area(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)
    pts = String.split(args.key, ".")

    if length(pts) > 1 do
      {_, arr} = List.pop_at(pts, -1)

      sup =
        Enum.join(arr, ".")
        |> Areas.get_area_by_key(context.current_user.client_id)

      if sup === nil do
        {:error, "Invalid key"}
      else
        args = Map.put(args, :up_id, sup.id)

        case Areas.create_area(args) do
          {:error, _changeset} -> {:error, "Erro"}
          {:ok, unit} -> {:ok, unit}
        end
      end
    else
      case Areas.create_area(args) do
        {:error, changeset} ->
          {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, unit} ->
          {:ok, unit}
      end
    end
  end

  def update_area(_, args, %{context: context}) do
    area = Areas.get_area_by_key(args.key, context.current_user.client_id)

    if area === nil do
      {:error, "Invalid key"}
    else
      case Areas.update_area(area, args) do
        {:error, changeset} ->
          {:error, message: "Update error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, area} ->
          {:ok, area}
      end
    end
  end

  def delete_area(_, args, %{context: context}) do
    area = Areas.get_area_by_key(args.key, context.current_user.client_id)

    if area === nil do
      {:error, "Invalid key"}
    else
      case Areas.delete_area(area) do
        {:error, changeset} ->
          {:error, message: "Delete error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, area} ->
          {:ok, area}
      end
    end
  end
end
