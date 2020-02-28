defmodule NorteWeb.Schema.Resolvers.ItemResolvers do
  alias Norte.Items
  alias NorteWeb.Schema.Middleware.ChangesetErrors

  def list_items(_, args, %{context: context}) do
    {:ok, Items.list_items(context.current_user.client_id, args)}
  end

  def get_item(_, %{key: key}, %{context: context}) do
    {:ok, Items.get_item_by_key(key, context.current_user.client_id)}
  end

  def create_item(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)
    pts = String.split(args.key, ".")

    if length(pts) > 1 do
      {_, arr} = List.pop_at(pts, -1)

      sup =
        Enum.join(arr, ".")
        |> Items.get_item_by_key(context.current_user.client_id)

      if sup === nil do
        {:error, "Invalid key"}
      else
        args = Map.put(args, :up_id, sup.id)

        case Items.create_item(args) do
          {:error, _changeset} -> {:error, "Erro"}
          {:ok, unit} -> {:ok, unit}
        end
      end
    else
      case Items.create_item(args) do
        {:error, changeset} ->
          {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, unit} ->
          {:ok, unit}
      end
    end
  end

  def update_item(_, args, %{context: context}) do
    item = Items.get_item_by_key(args.key, context.current_user.client_id)

    if item === nil do
      {:error, "Invalid key"}
    else
      case Items.update_item(item, args) do
        {:error, changeset} ->
          {:error, message: "Update error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, item} ->
          {:ok, item}
      end
    end
  end

  def delete_item(_, args, %{context: context}) do
    item = Items.get_item_by_key(args.key, context.current_user.client_id)

    if item === nil do
      {:error, "Invalid key"}
    else
      case Items.delete_item(item) do
        {:error, changeset} ->
          {:error, message: "Delete error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, item} ->
          {:ok, item}
      end
    end
  end

  # Mappings

  def list_mappings(_, %{item_key: item_key} = args, %{context: context}) do
    {:ok, Items.list_mappings(context.current_user.client_id, item_key, args)}
  end

  def get_mapping(_, %{id: id}, %{context: context}) do
    {:ok, Items.get_mapping(id, context.current_user.client_id)}
  end

  def create_mapping(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)

    case Items.create_mapping(args) do
      {:error, changeset} ->
        {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

      {:ok, unit} ->
        {:ok, unit}
    end
  end

  def update_mapping(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)

    mapping =
      Items.get_mapping_by_keys(args.item_key, args.unit_key, context.current_user.client_id)

    if mapping === nil do
      {:error, "Invalid key"}
    else
      case Items.update_mapping(mapping, args) do
        {:error, changeset} ->
          {:error, message: "Update error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, item} ->
          {:ok, item}
      end
    end
  end

  def delete_mapping(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)

    mapping =
      Items.get_mapping_by_keys(args.item_key, args.unit_key, context.current_user.client_id)

    if mapping === nil do
      {:error, "Invalid id"}
    else
      case Items.delete_mapping(mapping) do
        {:error, changeset} ->
          {:error, message: "Delete error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, item} ->
          {:ok, item}
      end
    end
  end
end
