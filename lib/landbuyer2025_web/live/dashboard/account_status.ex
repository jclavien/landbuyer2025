defmodule Landbuyer2025Web.Live.Dashboard.AccountStatus do
  use Phoenix.Component
  import Phoenix.Component

  def account_status_line(assigns) do
    ~H"""
    <div class="text-slate-400 ml-2 mt-1 text-sm flex items-center space-x-2">
      <%= if @account_display_id do %>
        <div>{@account_display_id}</div>
      <% end %>
      
      <%= if @strategy && @strategy.strategy_display_id do %>
        <div class="text-slate-500">&gt;</div>
        
        <div>{@strategy.strategy_display_id}</div>
      <% end %>
      
    <!-- Badge de statut -->
      <%= cond do %>
        <% @strat_status == :no_strat -> %>
          <div class="flex items-center space-x-2">
            <span class="text-slate-200 bg-slate-700 text-xs font-semibold px-2 py-0.5 rounded-full">
              no active strategy
            </span>
            
            <button
              phx-click="close_account"
              phx-value-id={@account.id}
              class="w-5 h-5 rounded bg-slate-700 hover:bg-slate-600 flex items-center justify-center"
              title="Delete account"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-4 h-4 text-red"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
            </button>
          </div>
        <% @strat_status == :create_strat -> %>
          <span class="text-slate-200 bg-slate-700 text-xs font-semibold px-2 py-0.5 rounded-full">
            creating ...
          </span>
        <% @strat_status == :edit_strat -> %>
          <span class="text-slate-200 bg-slate-700 text-xs font-semibold px-2 py-0.5 rounded-full">
            editing ...
          </span>
        <% @strat_status == :active_strat && @strategy && @strategy.status == "started" -> %>
          <span class="text-green bg-green/20 text-xs font-semibold px-2 py-0.5 rounded-full">
            LIVE
          </span>
        <% @strat_status == :active_strat && @strategy && @strategy.status == "stopped" -> %>
          <span class="text-red bg-red/20 text-xs font-semibold px-2 py-0.5 rounded-full">
            PAUSED
          </span>
        <% true -> %>
          <!-- rien -->
      <% end %>
    </div>
    """
  end
end
