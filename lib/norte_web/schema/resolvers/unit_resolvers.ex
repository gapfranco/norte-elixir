defmodule NorteWeb.Schema.Resolvers.UnitResolvers do
  alias Norte.Base

  def list_units(_, args, %{context: context}) do
    {:ok, Base.list_units(context.current_user.client_id, args)}
  end

  def get_unit(_, %{key: key}, %{context: context}) do
    {:ok, Base.get_unit_by_key(context.current_user.client_id, key)}
  end

  def create_unit(_, args, %{context: context}) do
    args = Map.put(args, :client_id, context.current_user.client_id)
    IO.inspect(args)
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
        {:ok, Base.create_unit(args)}
      end
    else
      {:ok, Base.create_unit(args)}
    end
  end
end
