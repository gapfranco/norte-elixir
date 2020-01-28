defmodule NorteWeb.Schema.Resolvers.RiskResolvers do
  alias Norte.Risks
  alias NorteWeb.Schema.Middleware.ChangesetErrors

  def list_risks(_, args, %{context: context}) do
    {:ok, Risks.list_risks(context.current_user.client_id, args)}
  end

  def get_risk(_, %{key: key}, %{context: context}) do
    {:ok, Risks.get_risk_by_key(key, context.current_user.client_id)}
  end

  def create_risk(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)
    pts = String.split(args.key, ".")

    if length(pts) > 1 do
      {_, arr} = List.pop_at(pts, -1)

      sup =
        Enum.join(arr, ".")
        |> Risks.get_risk_by_key(context.current_user.client_id)

      if sup === nil do
        {:error, "Invalid key"}
      else
        args = Map.put(args, :up_id, sup.id)

        case Risks.create_risk(args) do
          {:error, changeset} ->
            {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

          {:ok, unit} ->
            {:ok, unit}
        end
      end
    else
      case Risks.create_risk(args) do
        {:error, changeset} ->
          {:error, message: "Create error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, unit} ->
          {:ok, unit}
      end
    end
  end

  def update_risk(_, args, %{context: context}) do
    area = Risks.get_risk_by_key(args.key, context.current_user.client_id)

    if area === nil do
      {:error, "Invalid key"}
    else
      case Risks.update_risk(area, args) do
        {:error, changeset} ->
          {:error, message: "Update error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, area} ->
          {:ok, area}
      end
    end
  end

  def delete_risk(_, args, %{context: context}) do
    area = Risks.get_risk_by_key(args.key, context.current_user.client_id)

    if area === nil do
      {:error, "Invalid key"}
    else
      case Risks.delete_risk(area) do
        {:error, changeset} ->
          {:error, message: "Delete error", detail: ChangesetErrors.transform_errors(changeset)}

        {:ok, area} ->
          {:ok, area}
      end
    end
  end
end
