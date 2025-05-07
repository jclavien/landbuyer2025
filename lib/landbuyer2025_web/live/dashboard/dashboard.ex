defmodule Landbuyer2025Web.Live.Dashboard do
  use Phoenix.Component

  def overview_panel(assigns) do
    ~H"""
    <div class="w-full h-full bg-slate-800 rounded p-6">
      <h1 class="text-2xl font-bold">Overview</h1>
      <div class="mt-4">
        Vue globale : NAV total, nombre de comptes, résumé des performances...
      </div>
    </div>
    """
  end

  def account_panel(assigns) do
    ~H"""
    <div class="w-full h-full bg-slate-800 rounded p-6">
      <h1 class="text-2xl font-bold"><%= @account.name %></h1>
      <div class="mt-2 text-sm text-slate-400">
        Service: <%= @account.service %> | ID Oanda: <%= @account.id_oanda %>
      </div>
      <div class="mt-4">
        Bienvenue sur le tableau de bord de <%= @account.name %> !
        <!-- Ici tu pourras mettre graphiques, ordres, historique, etc. -->
      </div>
    </div>
    """
  end
end
