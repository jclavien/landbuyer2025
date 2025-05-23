defmodule Landbuyer2025Web.Footer do
  use Phoenix.Component

  def footer(assigns) do
    ~H"""
    <footer class="p-4 text-right pr-5 text-slate-400 text-sm">
      <p>© LANDBUYER 2025 by Yproky</p>

      <div class="fixed bottom-8 left-12 z-50 text-xs">
        <%= if Phoenix.Flash.get(@flash, :info) do %>
          <div class="text-left bg-green text-slate-200 p-1 pl-2 rounded mb-2 w-72">
            <%= Phoenix.Flash.get(@flash, :info) %>
          </div>
        <% end %>

        <%= if Phoenix.Flash.get(@flash, :error) do %>
          <div class="text-left bg-red text-slate-200 p-1 pl-2 rounded text-xs w-72 left-8">
            <%= Phoenix.Flash.get(@flash, :error) %>
          </div>
        <% end %>
      </div>
    </footer>
    """
  end
end
