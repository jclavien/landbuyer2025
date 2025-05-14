defmodule Landbuyer2025Web.FormValidator do
  def validate_required_fields(params, required_fields) do
    Enum.reduce(required_fields, %{}, fn field, acc ->
      value = Map.get(params, field, "") |> String.trim()
      error_key = String.to_existing_atom("#{field}_error")

      if value == "" do
        Map.put(acc, error_key, "required")
      else
        Map.put(acc, error_key, nil)
      end
    end)
  end

  def validate_currency_pair_format(params, field_name) do
    value = Map.get(params, field_name, "")

    case Regex.match?(~r/^[A-Z]{3}_[A-Z]{3}$/, value) do
      true -> %{:"#{field_name}_error" => nil}
      false -> %{:"#{field_name}_error" => "Use XXX_YYY"}
    end
  end

  def validate_integer_format(params, field_name) do
    value = Map.get(params, field_name, "") |> String.trim()

    case Integer.parse(value) do
      {_, ""} -> %{:"#{field_name}_error" => nil}
      _ -> %{:"#{field_name}_error" => "Must be an integer"}
    end
  end

  def validate_float_format(params, field_name) do
    value = Map.get(params, field_name, "") |> String.trim()

    case Float.parse(value) do
      {_, ""} -> %{:"#{field_name}_error" => nil}
      _ -> %{:"#{field_name}_error" => "Must be a number"}
    end
  end

  def validate_strategy_exists(params) do
    value = Map.get(params, "strategy_name", "") |> String.trim()

    valid_keys =
      Landbuyer2025.Strategies.all_modules()
      |> Enum.map(&Atom.to_string(&1.key()))
      |> Enum.reject(&(&1 == "empty"))

    if value in valid_keys do
      %{strategy_name_error: nil}
    else
      %{strategy_name_error: "Please select a strategy"}
    end
  end
end
