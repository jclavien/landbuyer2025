defmodule Landbuyer2025Web.Button do
  use Phoenix.Component

  def icon_button(assigns) do
    assigns =
      assigns
      |> assign_new(:d, fn -> "M12 4v16m8-8H4" end)
      |> assign_new(:bg_class, fn -> "bg-slate-800" end)
      |> assign_new(:hover_class, fn -> "hover:bg-slate-600" end)

    ~H"""
    <button
      type="button"
      phx-click={@phx_click}
      class={"grid place-content-center w-7 h-7 rounded #{@bg_class} #{@hover_class} text-slate-200"}>
      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path d={@d} stroke-linecap="round" stroke-linejoin="round" stroke-width="3" />
      </svg>
    </button>
    """
  end

end
