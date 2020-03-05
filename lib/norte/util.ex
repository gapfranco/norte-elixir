defmodule Norte.Util do
  import Ecto.Changeset
  use Timex

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

  def atom_field(field) do
    ret = Atom.to_string(field)

    if ret == "nil" do
      nil
    else
      ret
    end
  end

  def new_date(date, frequency) do
    case frequency do
      "diario" -> Timex.shift(date, days: 1)
      "semanal" -> Timex.shift(date, weeks: 1)
      "mensal" -> Timex.shift(date, months: 1)
      "bimestral" -> Timex.shift(date, months: 2)
      "trimestral" -> Timex.shift(date, months: 3)
      "semestral" -> Timex.shift(date, months: 6)
      "anual" -> Timex.shift(date, years: 1)
    end
  end
end
