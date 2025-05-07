defmodule Landbuyer2025Web.Live.Dashboard.Strategies do
  use Phoenix.Component
  import Landbuyer2025Web.Button

  # Bloc principal Strategy (affiche soit le bouton + soit la stratégie)
  def strategy_block(assigns) do
    ~H"""
    <div class="p-4 bg-slate-700 rounded mb-4">
      <h2 class="text-xl font-bold mb-2">Strategy</h2>

      <%= if @strategy do %>
        <div>
          <p><strong>Strategy:</strong> <%= @strategy.name %></p>
          <p><strong>Interval:</strong> <%= @strategy.interval %></p>
          <p><strong>Currency pair:</strong> <%= @strategy.currency_pair %></p>
          <p><strong>TP:</strong> <%= @strategy.take_profit %> pips</p>
          <p><strong>SL:</strong> <%= @strategy.stop_loss %> pips</p>
          <p><strong>Distance:</strong> <%= @strategy.distance %> pips</p>
          <p><strong>Size:</strong> <%= @strategy.size %></p>
          <p><strong>Max orders:</strong> <%= @strategy.max_orders %></p>

          <!-- Buttons -->
          <div class="flex space-x-2 mt-2">
            <button class="bg-green-600 hover:bg-green-500 px-2 py-1 rounded text-sm">▶️ Start</button>
            <button class="bg-yellow-600 hover:bg-yellow-500 px-2 py-1 rounded text-sm">⏸ Stop</button>
            <button class="bg-blue-600 hover:bg-blue-500 px-2 py-1 rounded text-sm">🧹 Clean</button>
            <button class="bg-red-600 hover:bg-red-500 px-2 py-1 rounded text-sm">❌ Close</button>
          </div>
        </div>
      <% else %>
        <.icon_button
        phx_click="add_strategy"
        d="M12 4v16m8-8H4"
        bg_class="bg-slate-800"
        hover_class="hover:bg-slate-600"
      />

      <% end %>
    </div>
    """
  end

  # Placeholder bloc Results and Stats
  def results_block(assigns) do
    ~H"""
    <div class="p-4 bg-slate-700 rounded mb-4">
      <h2 class="text-xl font-bold mb-2">Results and Stats</h2>
      <p class="italic text-slate-400">To be defined...</p>
    </div>
    """
  end

  # Placeholder graph principal
  def main_graph(assigns) do
    ~H"""
    <div class="p-4 bg-slate-700 rounded mb-4">
      <h2 class="text-xl font-bold mb-2">Main Graph (NAV + Price)</h2>
      <div class="h-48 bg-slate-600 rounded flex items-center justify-center">
        <p class="text-slate-400">Graph placeholder</p>
      </div>
    </div>
    """
  end

  # Placeholder pour les deux petits graphs
  def sub_graphs(assigns) do
    ~H"""
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div class="p-4 bg-slate-700 rounded">
        <h3 class="font-bold mb-2">Sub Graph 1</h3>
        <div class="h-32 bg-slate-600 rounded flex items-center justify-center">
          <p class="text-slate-400">Placeholder</p>
        </div>
      </div>
      <div class="p-4 bg-slate-700 rounded">
        <h3 class="font-bold mb-2">Sub Graph 2</h3>
        <div class="h-32 bg-slate-600 rounded flex items-center justify-center">
          <p class="text-slate-400">Placeholder</p>
        </div>
      </div>
    </div>
    """
  end
end
