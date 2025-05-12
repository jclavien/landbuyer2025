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
end
