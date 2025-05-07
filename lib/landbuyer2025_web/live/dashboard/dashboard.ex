defmodule Landbuyer2025Web.Live.Dashboard do
  use Phoenix.Component
  import Landbuyer2025Web.Live.Dashboard.Strategies


  def overview_panel(assigns) do
    ~H"""
    <div class="w-full h-full bg-slate-800 rounded p-6">
      <h1 class="text-2xl font-bold">OVERVIEW</h1>
      <div class="mt-4">
        Vue globale : NAV total, nombre de comptes, résumé des performances...
      </div>
    </div>
    """
  end

  def account_panel(assigns) do
    ~H"""
    <div class="w-full h-full bg-slate-800 rounded p-6 space-y-6">
      <!-- Titre principal -->
      <div>
        <h1 class="text-2xl font-bold"><%= @account.name %></h1>
        <div class="mt-1 text-sm text-slate-400">
          Service: <%= @account.service %> | ID Oanda: <%= @account.id_oanda %>
        </div>
      </div>

      <div class="flex gap-6 mb-6">
        <!-- Bloc Strategy -->
        <div class="w-[40rem] h-48 bg-slate-700 rounded flex flex-col">
          <.strategy_block strategy={nil} />
        </div>

        <!-- Bloc Results and Stats -->
        <div class="w-[40rem] h-48 bg-slate-700 rounded p-4 flex flex-col">
          <h2 class="text-xl font-semibold mb-2">Results and stats</h2>
          <p class="text-sm text-slate-400 italic">TBD</p>
        </div>
      </div>

        <!-- Graph principal -->
        <div class="bg-slate-700 rounded p-4 mb-6">
          <h2 class="text-xl font-semibold mb-2">Graph 1 - Market price + NAV</h2>
          <p class="text-sm text-slate-400">[Placeholder for main graph]</p>
        </div>

        <!-- Deux sous-graphs -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="bg-slate-700 rounded p-4">
            <h3 class="text-lg font-semibold mb-2">Graph 2 - P/L + Position size</h3>
            <p class="text-sm text-slate-400">[Placeholder for sub-graph 1]</p>
          </div>
          <div class="bg-slate-700 rounded p-4">
            <h3 class="text-lg font-semibold mb-2">Graph 3 - P/L + Position size</h3>
            <p class="text-sm text-slate-400">[Placeholder for sub-graph 2]</p>
          </div>
        </div>
    </div>
    """
  end
end
