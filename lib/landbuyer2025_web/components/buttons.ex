defmodule Landbuyer2025Web.Button do
  use Phoenix.Component

  def icon_button(assigns) do
    assigns =
      assigns
      |> assign_new(:d, fn -> "M12 4v16m8-8H4" end)
      |> assign_new(:bg_class, fn -> "bg-slate-800" end)
      |> assign_new(:hover_class, fn -> "hover:bg-slate-600" end)
      |> assign_new(:stroke_color, fn -> "white" end)
      |> assign_new(:title, fn -> nil end)
      |> assign_new(:icon_class, fn -> "w-5 h-5" end)
      |> assign_new(:button_class, fn -> "w-7 h-7" end)
      |> assign_new(:stroke_width, fn -> "3" end)

    ~H"""
    <button
      type="button"
      phx-click={@phx_click}
      title={@title}
      class={"grid place-content-center rounded #{@stroke_width} #{@bg_class} #{@hover_class} #{@icon_class} #{@button_class} text-slate-200"}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class={@icon_class}
        fill="none"
        viewBox="0 0 24 24"
        stroke={@stroke_color}
      >
        <path d={@d} stroke-linecap="round" stroke-linejoin="round" stroke-width={@stroke_width} />
      </svg>
    </button>
    """
  end
end
