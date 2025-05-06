defmodule Landbuyer2025Web.Footer do
  use Phoenix.Component

  def footer(assigns) do
    ~H"""
    <footer class="p-4 text-center text-slate-400 text-sm">
      <p>© LANDBUYER 2025 by Yproky</p>

      <div class="fixed bottom-8 left-12 z-50 text-xs">
        <%= if live_flash(@flash, :info) do %>
          <div class="bg-green text-slate-200 p-1 rounded mb-2 w-72">
            <%= live_flash(@flash, :info) %>
          </div>
        <% end %>

        <%= if live_flash(@flash, :error) do %>
          <div class="bg-red text-slate-200 p-1 rounded text-xs w-72 left-8">
            <%= live_flash(@flash, :error) %>
          </div>
        <% end %>
      </div>
    </footer>
    """
  end
end
