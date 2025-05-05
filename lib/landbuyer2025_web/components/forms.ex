defmodule Landbuyer2025Web.Forms do
  use Phoenix.Component

  def text_input(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> "text" end)
      |> assign_new(:value, fn -> "" end)

    ~H"""
    <input
      type={@type}
      name={@name}
      value={@value}
      placeholder={@placeholder}
      class="w-full h-8 p-2 rounded bg-slate-200 text-slate-700 border border-slate-800 text-sm placeholder:italic placeholder-slate-400"
    />
    """
  end
end
