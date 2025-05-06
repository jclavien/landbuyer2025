defmodule Landbuyer2025Web.Forms do
  use Phoenix.Component

 def text_input(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> "text" end)
      |> assign_new(:value, fn -> "" end)
      |> assign_new(:error, fn -> nil end)

    border_class =
      if assigns.error do
        "border-red"
      else
        "border-slate-700"
      end

    assigns = assign(assigns, :border_class, border_class)

    ~H"""
    <div>
      <input
        type={@type}
        name={@name}
        value={@value}
        placeholder={@placeholder}
        class={"w-full h-8 p-2 rounded bg-slate-200 text-slate-700 border #{@border_class} text-sm placeholder:italic placeholder-slate-400"}
      />
      <%= if @error do %>
        <div class="text-red text-xs mt-1"><%= @error %></div>
      <% end %>
    </div>
    """
  end
end
