defmodule Landbuyer2025Web.Live.Dashboard.StrategiesBackup do
  use Phoenix.Component
  import Landbuyer2025Web.Button
  import Landbuyer2025Web.Forms

  # En haut du fichier
  use Phoenix.Component

  # Composant privé pour afficher une paire label/valeur
  attr :label, :string, required: true
  attr :value, :any, required: true

  defp strategy_value(assigns) do
    ~H"""
    <div class="flex flex-col justify-end h-12">
      <div class="text-sm text-slate-200">{@label}</div>
      
      <div class="text-xl text-slate-200">{@value}</div>
    </div>
    """
  end

  # Bloc principal Strategy (affiche soit le bouton + soit la stratégie)
  def strategy_block(assigns) do
    assigns =
      assigns
      |> assign_new(:show_strategy_form, fn -> false end)
      |> assign_new(:strategy_form_data, fn -> %{} end)
      |> assign_new(:edit_mode, fn -> false end)

    ~H"""
    <div class="flex justify-between items-center mb-2 ml-2 mb-[18px]">
      <h2 class="text-xl font-bold">Strategy</h2>
      
      <div class="flex items-center justify-end space-x-2 mt-[4px] mr-[6px]">
        <%= if @edit_mode do %>
          <!-- Mode édition actif : seul le bouton retour -->
          <.icon_button phx_click="close_strategy_form" d="M15 19l-7-7 7-7" />
        <% else %>
          <%= if @strategy && @strategy.status == "stopped" do %>
            <.icon_button
              phx_click="edit_strategy"
              d="M3 17.25V21h3.75l11.06-11.06-3.75-3.75L3 17.25z"
            /> <.icon_button phx_click="delete_strategy" d="M6 18L18 6M6 6l12 12" />
            <.icon_button phx_click="start_strategy" d="M5 3v18l15-9L5 3z" stroke_color="green" />
          <% end %>
          
          <%= if @strategy && @strategy.status == "started" do %>
            <.icon_button phx_click="stop_strategy" d="M6 6h12v12H6z" stroke_color="red" />
          <% end %>
          
          <%= if is_nil(@strategy) && !@show_strategy_form do %>
            <.icon_button phx_click="add_strategy" d="M12 4v16m8-8H4" />
          <% end %>
        <% end %>
      </div>
    </div>

    <%= if @show_strategy_form do %>
      <.add_strategy_form strategy_form_data={@strategy_form_data} edit_mode={@edit_mode} />
    <% end %>

    <%= if @strategy && !@edit_mode do %>
      <div class="grid grid-cols-1 md:grid-cols-4 gap-x-6 gap-y-[4px] ml-4 mt-[8px]">
        <.strategy_value label="Strategy" value={@strategy.strategy_name} />
        <.strategy_value label="Interval (ms)" value={"#{@strategy.interval} ms"} />
        <.strategy_value label="Currency pair" value={@strategy.currency_pair} />
        <.strategy_value label="Decimals" value={@strategy.decimals} />
        <.strategy_value label="Take profit" value={"#{@strategy.take_profit} pips"} />
        <.strategy_value label="Stop loss" value={"#{@strategy.stop_loss} pips"} />
        <.strategy_value label="Distance" value={"#{@strategy.distance} pips"} />
        <.strategy_value label="Order size" value={@strategy.order_size} />
        <.strategy_value label="Max orders" value={@strategy.max_orders} />
        <.strategy_value label="Direction" value={@strategy.direction} />
      </div>
    <% end %>

    <%= if is_nil(@strategy) && !@show_strategy_form && !@edit_mode do %>
      <div class="flex justify-center items-center h-32">
        <p class="text-slate-400 text-base">no active strategy</p>
      </div>
    <% end %>
    """
  end

  def add_strategy_form(assigns) do
    strategy_modules = Landbuyer2025.Strategies.all_modules()

    strategy_options =
      Enum.reduce(strategy_modules, [], fn mod, acc ->
        case Code.ensure_loaded?(mod) do
          true ->
            [{mod.name(), Atom.to_string(mod.key())} | acc]

          false ->
            IO.warn("Module #{inspect(mod)} not loaded!")
            acc
        end
      end)
      |> Enum.reverse()

    assigns =
      assigns
      |> assign(:strategy_options, strategy_options)
      |> assign(:strategy_form_data, assigns.strategy_form_data)
      |> assign_new(:edit_mode, fn -> false end)

    ~H"""
    <form
      phx-submit={(@edit_mode && "update_strategy") || "create_strategy"}
      class="p-4 rounded text-slate-200 -mt-1"
    >
      <div class="grid grid-cols-1 md:grid-cols-4 gap-x-6 gap-y-4">
        <!-- Ligne 1 -->
        <div>
          <%= if @edit_mode do %>
            <.strategy_value label="Strategy" value={@strategy_form_data.strategy_name} />
          <% else %>
            <label class="block text-sm">Strategy</label>
            <select
              name="strategy_name"
              class="w-full h-8 rounded bg-slate-200 text-slate-700 text-xs"
            >
              <%= for {label, value} <- @strategy_options do %>
                <option value={value} selected={value == @strategy_form_data.strategy_name}>
                  {label}
                </option>
              <% end %>
            </select>
            
            <%= if @strategy_form_data.strategy_name_error do %>
              <div class="text-red text-xs mt-1">{@strategy_form_data.strategy_name_error}</div>
            <% end %>
          <% end %>
        </div>
        
        <%= if @edit_mode do %>
          <.strategy_value label="Interval (ms)" value={"#{@strategy_form_data.interval} ms"} />
          <.strategy_value label="Currency pair" value={@strategy_form_data.currency_pair} />
          <.strategy_value label="Decimals" value={@strategy_form_data.decimals} />
        <% else %>
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
        <% end %>
        
    <!-- Ligne 2 -->
        <div>
          <label class="block text-sm">Take profit</label>
          <.text_input
            name="take_profit"
            value={@strategy_form_data.take_profit}
            error={@strategy_form_data.take_profit_error}
            class={@edit_mode && "border border-green"}
            placeholder="in pips"
          />
        </div>
        
        <div>
          <label class="block text-sm">Stop loss</label>
          <.text_input
            name="stop_loss"
            value={@strategy_form_data.stop_loss}
            error={@strategy_form_data.stop_loss_error}
            class={@edit_mode && "border border-green"}
            placeholder="in pips"
          />
        </div>
        
        <div>
          <label class="block text-sm">Distance</label>
          <.text_input
            name="distance"
            value={@strategy_form_data.distance}
            error={@strategy_form_data.distance_error}
            class={@edit_mode && "border border-green"}
            placeholder="in pips"
          />
        </div>
        
        <div>
          <label class="block text-sm">Order size</label>
          <.text_input
            name="order_size"
            value={@strategy_form_data.order_size}
            error={@strategy_form_data.order_size_error}
            class={@edit_mode && "border border-green"}
            placeholder="ex: 10"
          />
        </div>
        
    <!-- Ligne 3 -->
        <div>
          <label class="block text-sm">Max orders</label>
          <.text_input
            name="max_orders"
            value={@strategy_form_data.max_orders}
            error={@strategy_form_data.max_orders_error}
            class={@edit_mode && "border border-green"}
            placeholder="ex: 20"
          />
        </div>
        
        <div>
          <%= if @edit_mode do %>
            <.strategy_value label="Direction" value={@strategy_form_data.direction} />
          <% else %>
            <label class="block text-sm">Direction</label>
            <select name="direction" class="w-full h-8 rounded bg-slate-200 text-slate-700 text-xs">
              <option value="LONG" selected={@strategy_form_data.direction == "LONG"}>LONG</option>
              
              <option value="SHORT" selected={@strategy_form_data.direction == "SHORT"}>SHORT</option>
            </select>
          <% end %>
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
end
