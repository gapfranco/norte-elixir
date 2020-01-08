defmodule Norte.Util do
  import Ecto.Changeset

  def validate_key_format(changeset, field) do
    validate_change(changeset, field, fn _field, value ->
      cond do
        validate_key(value) -> []
        true -> [{field, "invalid key format"}]
      end
    end)
  end

  defp validate_key(key) do
    if Regex.match?(~r/^[a-zA-Z0-9.]+$/, key) do
      pts = String.split(key, ".")
      Enum.all?(pts, fn s -> String.length(s) > 0 end)
    else
      false
    end
  end
end
