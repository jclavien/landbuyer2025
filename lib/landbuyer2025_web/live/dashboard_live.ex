defmodule Landbuyer2025Web.Live.DashboardLive do
    use Phoenix.LiveView
    import Landbuyer2025Web.Header
    import Landbuyer2025Web.Footer
    import Landbuyer2025Web.Live.Dashboard.Accounts

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

    def render(assigns) do
     ~H"""
<div class="min-h-screen flex flex-col bg-slate-700">
  <.header />

  <main class="flex flex-1">
    <!-- Colonne gauche -->
    <div class="w-1/4 bg-slate-700 p-2 flex flex-col ml-8">
      <.account name="Overview" nav={0.0} is_overview={true} />
      <.account name="LB USDCHF" nav={1234.56} is_overview={false} />
      <.account name="LB EURJPY" nav={5678.90} is_overview={false} />
    </div>

    <!-- Contenu principal -->
    <div class="flex-1 p-4 text-slate-200">
      Bienvenue sur le Dashboard
    </div>
  </main>

  <.footer />
</div>
"""
    end
  end
