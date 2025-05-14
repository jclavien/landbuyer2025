defmodule Landbuyer2025Web.Live.Dashboard do
  use Phoenix.Component
  import Landbuyer2025Web.Live.Dashboard.Strategies
  import Landbuyer2025Web.Live.Dashboard.Results
  import Landbuyer2025Web.Live.Dashboard.Graphs

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
    IO.inspect(assigns.strategy, label: "🔥 STRATEGY IN ACCOUNT_PANEL")

    assigns =
      assigns
      |> assign_new(:account, fn -> nil end)
      |> assign_new(:strategy, fn -> nil end)
      |> assign_new(:show_strategy_form, fn -> false end)
      |> assign_new(:strategy_form_data, fn -> %{} end)

    ~H"""
    <div class="w-full h-full bg-slate-800 rounded p-4 ml-1">
      <!-- Titre principal -->
      <div class="mb-[12px]">
        <%= if @account do %>
          <h1 class="text-2xl font-bold ml-2">{@account.name}</h1>
          
          <div class="text-sm text-slate-400 ml-2">
            Service: {@account.service} | ID Oanda: {@account.id_oanda}
          </div>
        <% else %>
          <h1 class="text-2xl font-bold ml-2 text-slate-400 italic">No account selected</h1>
        <% end %>
      </div>
      
    <!-- Ligne : Strategy + Results -->
      <div class="flex gap-[18px] mb-[18px] ml-2">
        <!-- Bloc Strategy -->
        <div class="w-[640px] h-[280px] bg-slate-700 p-2 rounded flex flex-col">
          <.strategy_block
            strategy={@strategy}
            show_strategy_form={@show_strategy_form}
            strategy_form_data={@strategy_form_data}
          />
        </div>
        
    <!-- Bloc Results and Stats -->
        <div class="w-[640px] h-[280px] bg-slate-700 p-2 rounded flex flex-col">
          <.results_block />
        </div>
      </div>
      
    <!-- Graph principal -->
      <div class="w-[1300px] h-[420px] bg-slate-700 rounded p-2 mb-[18px] ml-2">
        <.main_graph />
      </div>
      
    <!-- Deux sous-graphs -->
      <div class="flex gap-[18px] ml-2">
        <div class="w-[640px] h-[200px] bg-slate-700 rounded p-2">
          <.sub_graphs />
        </div>
        
        <div class="w-[640px] h-[200px] bg-slate-700 rounded p-2">
          <.sub_graphs />
        </div>
      </div>
    </div>
    """
  end
end
