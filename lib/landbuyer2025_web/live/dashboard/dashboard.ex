defmodule Landbuyer2025Web.Live.Dashboard do
  use Phoenix.Component
  import Landbuyer2025Web.Live.Dashboard.Strategies
  import Landbuyer2025Web.Live.Dashboard.Results
  # import Landbuyer2025Web.Live.Dashboard.Graphs
  import Landbuyer2025Web.Live.Dashboard.AccountStatus

  def overview_panel(assigns) do
    ~H"""
    <div class="w-full h-full bg-slate-800 rounded p-4 ml-1">
      <h1 class="text-2xl font-bold ml-2">OVERVIEW</h1>
      
      <div class="text-slate-400 ml-2">
        Vue globale : NAV total, nombre de comptes, résumé des performances...
      </div>
    </div>
    """
  end

  def account_panel(assigns) do
    ~H"""
    <div class="w-full h-full bg-slate-800 rounded p-4 ml-1">
      <!-- Titre dynamique -->
      <h1 class="text-2xl font-bold ml-2">{@account.name}</h1>
      
    <!-- Ligne de statuts -->
      <.account_status_line
        account={@account}
        account_display_id={@account.account_display_id}
        strat_status={@strat_status}
        strategy={@strategy}
      />
      
    <!-- Ligne des blocs -->
      <div class="flex gap-[18px] mb-[18px] mt-4 ml-2">
        <!-- Bloc Strategy -->
        <div class="w-[640px] h-[300px] bg-slate-700 p-2 rounded flex flex-col">
          <.strategy_block
            strategy={@strategy}
            strat_status={@strat_status}
            strategy_form_data={@strategy_form_data}
          />
        </div>
        
    <!-- Bloc Results -->
        <div class="w-[640px] h-[300px] bg-slate-700 p-2 rounded flex flex-col">
          <.results_block />
        </div>
      </div>
    </div>
    """
  end
end
