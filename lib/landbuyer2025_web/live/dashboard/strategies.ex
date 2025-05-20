defmodule Landbuyer2025Web.Live.Dashboard.Strategies do
  use Phoenix.Component
  import Landbuyer2025Web.Button
  import Landbuyer2025Web.Forms

  def strategy_block(assigns) do
    ~H"""
    <!-- Titre + Toolbar -->
    <div class="flex justify-between items-start mb-2 ml-2 mr-2">
      <h2 class="text-xl font-bold">Strategy</h2>
      
      <div class="mt-1">
        <.strat_toolbar strat_status={@strat_status} strategy={@strategy} />
      </div>
    </div>

    <!-- Affichage dynamique -->
    <%= if @strat_status == :no_strat do %>
      <div class="flex justify-center items-center h-24">
        <p class="text-gray-400 text-base">no active strategy</p>
      </div>
    <% end %>

    <%= if @strat_status == :create_strat do %>
      <.add_strategy_form strategy_form_data={@strategy_form_data} />
    <% end %>

    <%= if @strat_status == :edit_strat do %>
      <.edit_strategy_form strategy_form_data={@strategy_form_data} />
    <% end %>

    <%= if @strat_status == :active_strat do %>
      <.display_strategy strategy_form_data={@strategy_form_data} />
    <% end %>
    """
  end

  def strat_toolbar(assigns) do
    ~H"""
    <%= case {@strat_status, @strategy && @strategy.status} do %>
      <% {:no_strat, _} -> %>
        <.icon_button
          phx_click="add_strategy"
          d="M12 4v16m8-8H4"
          title="Add strategy"
          icon_class="w-4 h-4"
        />
      <% {:create_strat, _} -> %>
        <.icon_button
          phx_click="close_strategy_form"
          d="M15 19l-7-7 7-7"
          title="Close form"
          icon_class="w-4 h-4"
        />
      <% {:edit_strat, _} -> %>
        <.icon_button
          phx_click="close_edit_strategy_form"
          d="M15 19l-7-7 7-7"
          title="Close form"
          icon_class="w-4 h-4"
        />
      <% {:active_strat, "stopped"} -> %>
        <div class="flex space-x-2">
          <.icon_button
            phx_click="edit_strategy"
            d="M11.078 2.25c-.917 0-1.699.663-1.85 1.567L9.05 4.889c-.02.12-.115.26-.297.348a7.493 7.493 0 0 0-.986.57c-.166.115-.334.126-.45.083L6.3 5.508a1.875 1.875 0 0 0-2.282.819l-.922 1.597a1.875 1.875 0 0 0 .432 2.385l.84.692c.095.078.17.229.154.43a7.598 7.598 0 0 0 0 1.139c.015.2-.059.352-.153.43l-.841.692a1.875 1.875 0 0 0-.432 2.385l.922 1.597a1.875 1.875 0 0 0 2.282.818l1.019-.382c.115-.043.283-.031.45.082.312.214.641.405.985.57.182.088.277.228.297.35l.178 1.071c.151.904.933 1.567 1.85 1.567h1.844c.916 0 1.699-.663 1.85-1.567l.178-1.072c.02-.12.114-.26.297-.349.344-.165.673-.356.985-.57.167-.114.335-.125.45-.082l1.02.382a1.875 1.875 0 0 0 2.28-.819l.923-1.597a1.875 1.875 0 0 0-.432-2.385l-.84-.692c-.095-.078-.17-.229-.154-.43a7.614 7.614 0 0 0 0-1.139c-.016-.2.059-.352.153-.43l.84-.692c.708-.582.891-1.59.433-2.385l-.922-1.597a1.875 1.875 0 0 0-2.282-.818l-1.02.382c-.114.043-.282.031-.449-.083a7.49 7.49 0 0 0-.985-.57c-.183-.087-.277-.227-.297-.348l-.179-1.072a1.875 1.875 0 0 0-1.85-1.567h-1.843ZM12 15.75a3.75 3.75 0 1 0 0-7.5 3.75 3.75 0 0 0 0 7.5Z"
            title="Edit strategy"
            icon_class="w-4 h-4"
            stroke_width="2"
          />
          <.icon_button
            phx_click="delete_strategy"
            d="M6 18L18 6M6 6l12 12"
            title="Delete strategy"
            icon_class="w-4 h-4"
          />
          <.icon_button
            phx_click="start_strategy"
            d="M5 3v18l15-9L5 3z"
            stroke_color="green"
            icon_class="w-4 h-4"
            title="Launch strategy"
          />
        </div>
      <% {:active_strat, "started"} -> %>
        <.icon_button
          phx_click="stop_strategy"
          icon_class="w-7 h-7"
          button_class="w-7 h-7"
          d="M10 9v6m4-6v6"
          stroke_color="red"
          title="Stop strategy"
          stroke_width="2.5"
        />
      <% _ -> %>
        <!-- Rien -->
    <% end %>
    """
  end

  defp strategy_value(assigns) do
    ~H"""
    <div class="flex flex-col justify-start h-[68px]">
      <div class="text-sm text-slate-200">{@label}</div>
      
      <div class="text-xl text-slate-200">{@value}</div>
    </div>
    """
  end

  def add_strategy_form(assigns) do
    strategy_modules = Landbuyer2025.Strategies.all_modules()

    strategy_options =
      strategy_modules
      |> Enum.filter(&Code.ensure_loaded?/1)
      |> Enum.map(fn mod -> {mod.name(), Atom.to_string(mod.key())} end)

    assigns =
      assigns
      |> assign(:strategy_options, strategy_options)

    ~H"""
    <form phx-submit="create_strategy" class="p-4 rounded text-slate-200 -mt-1">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-x-6 gap-y-4">
        <!-- Ligne 1 -->
        <div class="h-[68px] flex flex-col justify-start">
          <label class="block text-sm">Strategy</label>
          <select name="strategy_name" class="w-full h-8 rounded bg-slate-200 text-slate-700 text-xs">
            <%= for {label, value} <- @strategy_options do %>
              <option value={value} selected={value == @strategy_form_data.strategy_name}>
                {label}
              </option>
            <% end %>
          </select>
          
          <%= if @strategy_form_data.strategy_name_error do %>
            <div class="text-red text-xs mt-1">{@strategy_form_data.strategy_name_error}</div>
          <% end %>
        </div>
        
        <div>
          <label class="block text-sm">Interval (ms)</label>
          <.text_input
            name="interval"
            value={@strategy_form_data.interval}
            error={@strategy_form_data.interval_error}
            placeholder="1000ms = 1sec"
          />
        </div>
        
        <div>
          <label class="block text-sm">Currency pair</label>
          <.text_input
            name="currency_pair"
            value={@strategy_form_data.currency_pair}
            error={@strategy_form_data.currency_pair_error}
            placeholder="ex: USD_CHF"
          />
        </div>
        
        <div>
          <label class="block text-sm">Decimals</label>
          <.text_input
            name="decimals"
            value={@strategy_form_data.decimals}
            error={@strategy_form_data.decimals_error}
            placeholder="ex: 4"
          />
        </div>
        
    <!-- Ligne 2 -->
        <div class="h-[68px] flex flex-col justify-start">
          <label class="block text-sm">Take profit</label>
          <.text_input
            name="take_profit"
            value={@strategy_form_data.take_profit}
            error={@strategy_form_data.take_profit_error}
            placeholder="in pips"
          />
        </div>
        
        <div>
          <label class="block text-sm">Stop loss</label>
          <.text_input
            name="stop_loss"
            value={@strategy_form_data.stop_loss}
            error={@strategy_form_data.stop_loss_error}
            placeholder="in pips"
          />
        </div>
        
        <div>
          <label class="block text-sm">Distance</label>
          <.text_input
            name="distance"
            value={@strategy_form_data.distance}
            error={@strategy_form_data.distance_error}
            placeholder="in pips"
          />
        </div>
        
        <div>
          <label class="block text-sm">Order size</label>
          <.text_input
            name="order_size"
            value={@strategy_form_data.order_size}
            error={@strategy_form_data.order_size_error}
            placeholder="ex: 10"
          />
        </div>
        
    <!-- Ligne 3 -->
        <div class="h-[68px] flex flex-col justify-start">
          <label class="block text-sm">Max orders</label>
          <.text_input
            name="max_orders"
            value={@strategy_form_data.max_orders}
            error={@strategy_form_data.max_orders_error}
            placeholder="ex: 20"
          />
        </div>
        
        <div>
          <label class="block text-sm">Direction</label>
          <select name="direction" class="w-full h-8 rounded bg-slate-200 text-slate-700 text-xs">
            <option value="LONG" selected={@strategy_form_data.direction == "LONG"}>LONG</option>
            
            <option value="SHORT" selected={@strategy_form_data.direction == "SHORT"}>SHORT</option>
          </select>
        </div>
        
        <div></div>
        
    <!-- Bouton submit -->
        <div class="flex justify-end mt-[24px]">
          <button
            type="submit"
            class="grid place-content-center w-7 h-7 rounded bg-slate-800 hover:bg-slate-600 text-slate-200"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="w-4 h-4"
              fill="none"
              viewBox="0 0 24 24"
              stroke="green"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="5"
                d="M5 13l4 4L19 7"
              />
            </svg>
          </button>
        </div>
      </div>
    </form>
    """
  end

  def edit_strategy_form(assigns) do
    ~H"""
    <form phx-submit="update_strategy" class="p-4 rounded text-slate-200 -mt-1">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-x-6 gap-y-4">
        <!-- Ligne 1 -->
        <.strategy_value label="Strategy" value={@strategy_form_data.strategy_name} />
        <.strategy_value label="Interval (ms)" value={@strategy_form_data.interval} />
        <.strategy_value label="Currency pair" value={@strategy_form_data.currency_pair} />
        <.strategy_value label="Decimals" value={@strategy_form_data.decimals} />
        
    <!-- Ligne 2 -->
        <div class="h-[68px] flex flex-col justify-start">
          <label class="block text-sm">Take profit</label>
          <.text_input
            name="take_profit"
            value={@strategy_form_data.take_profit}
            error={@strategy_form_data.take_profit_error}
            class="border border-green"
            placeholder="in pips"
          />
        </div>
        
        <div>
          <label class="block text-sm">Stop loss</label>
          <.text_input
            name="stop_loss"
            value={@strategy_form_data.stop_loss}
            error={@strategy_form_data.stop_loss_error}
            class="border border-green"
            placeholder="in pips"
          />
        </div>
        
        <div>
          <label class="block text-sm">Distance</label>
          <.text_input
            name="distance"
            value={@strategy_form_data.distance}
            error={@strategy_form_data.distance_error}
            class="border border-green"
            placeholder="in pips"
          />
        </div>
        
        <div>
          <label class="block text-sm">Order size</label>
          <.text_input
            name="order_size"
            value={@strategy_form_data.order_size}
            error={@strategy_form_data.order_size_error}
            class="border border-green"
            placeholder="ex: 10"
          />
        </div>
        
    <!-- Ligne 3 -->
        <div class="h-[68px] flex flex-col justify-start">
          <label class="block text-sm">Max orders</label>
          <.text_input
            name="max_orders"
            value={@strategy_form_data.max_orders}
            error={@strategy_form_data.max_orders_error}
            class="border border-green"
            placeholder="ex: 20"
          />
        </div>
         <.strategy_value label="Direction" value={@strategy_form_data.direction} />
        <div></div>
        <!-- Bouton submit -->
        <div class="flex justify-end mt-[24px]">
          <button
            type="submit"
            class="grid place-content-center w-7 h-7 rounded bg-slate-800 hover:bg-slate-600 text-slate-200"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="w-4 h-4"
              fill="none"
              viewBox="0 0 24 24"
              stroke="green"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="5"
                d="M5 13l4 4L19 7"
              />
            </svg>
          </button>
        </div>
      </div>
    </form>
    """
  end

  def display_strategy(assigns) do
    ~H"""
    <div class="p-4 rounded text-slate-200 -mt-1">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-x-6 gap-y-4">
        <!-- Ligne 1 -->
        <.strategy_value label="Strategy" value={@strategy_form_data.strategy_name} />
        <.strategy_value label="Interval (ms)" value={@strategy_form_data.interval} />
        <.strategy_value label="Currency pair" value={@strategy_form_data.currency_pair} />
        <.strategy_value label="Decimals" value={@strategy_form_data.decimals} />
        
    <!-- Ligne 2 -->
        <.strategy_value label="Take profit" value={@strategy_form_data.take_profit} />
        <.strategy_value label="Stop loss" value={@strategy_form_data.stop_loss} />
        <.strategy_value label="Distance" value={@strategy_form_data.distance} />
        <.strategy_value label="Order size" value={@strategy_form_data.order_size} />
        
    <!-- Ligne 3 -->

        <.strategy_value label="Max orders" value={@strategy_form_data.max_orders} />
        <.strategy_value label="Direction" value={@strategy_form_data.direction} />
        <div></div>
        
        <div></div>
      </div>
    </div>
    """
  end
end
