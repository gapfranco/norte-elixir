defmodule NorteWeb.Schema.Resolvers.UnitResolvers do
  alias Norte.Base
  alias NorteWeb.Schema.Middleware.ChangesetErrors

  def list_units(_, args, %{context: context}) do
    {:ok, Base.list_units(context.current_user.client_id, args)}
  end

  def get_unit(_, %{key: key}, %{context: context}) do
    {:ok, Base.get_unit_by_key(key, context.current_user.client_id)}
  end

  def create_unit(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)
    pts = String.split(args.key, ".")

    if length(pts) > 1 do
      {_, arr} = List.pop_at(pts, -1)

      sup =
        Enum.join(arr, ".")
        |> Base.get_unit_by_key(context.current_user.client_id)

      if sup === nil do
        {:error, "Invalid key"}
      else
        args = Map.put(args, :up_id, sup.id)

        case Base.create_unit(args) do
          {:error, _changeset} -> {:error, "Erro"}
          {:ok, unit} -> {:ok, unit}
        end
      end
    else
      case Base.create_unit(args) do
        {:error, changeset} ->
          {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, unit} ->
          {:ok, unit}
      end
    end
  end

  def update_unit(_, args, %{context: context}) do
    unit = Base.get_unit_by_key(args.key, context.current_user.client_id)

    if unit === nil do
      {:error, "Invalid key"}
    else
      case Base.update_unit(unit, args) do
        {:error, changeset} ->
          {:error, message: "Update error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, unit} ->
          {:ok, unit}
      end
    end
  end

  def delete_unit(_, args, %{context: context}) do
    unit = Base.get_unit_by_key(args.key, context.current_user.client_id)

    if unit === nil do
      {:error, "Invalid key"}
    else
      case Base.delete_unit(unit) do
        {:error, changeset} ->
          {:error, message: "Delete error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, unit} ->
          {:ok, unit}
      end
    end
  end
end
