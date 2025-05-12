defmodule Landbuyer2025Web.Live.Dashboard.Strategies do
  use Phoenix.Component
  import Landbuyer2025Web.Button
  import Landbuyer2025Web.Forms


  # Bloc principal Strategy (affiche soit le bouton + soit la stratégie)
  def strategy_block(assigns) do
    IO.inspect(assigns, label: "ASSIGNS STRATEGY")
  assigns =
    assigns
    |> assign_new(:show_strategy_form, fn -> false end)
    |> assign_new(:strategy_form_data, fn -> %{} end)
    ~H"""
      <div class="flex justify-between items-center mb-2 ml-2">
        <h2 class="text-xl font-bold">Strategy</h2>

        <%= if Map.get(assigns, :strategy) == nil do %>
          <%= if @show_strategy_form do %>
            <.icon_button
              phx_click="close_strategy_form"
              d="M15 19l-7-7 7-7"
              bg_class="bg-slate-800"
              hover_class="hover:bg-slate-600"
            />
          <% else %>
            <.icon_button
              phx_click="add_strategy"
              d="M12 4v16m8-8H4"
              bg_class="bg-slate-800"
              hover_class="hover:bg-slate-600"
            />
          <% end %>
        <% end %>
      </div>


     <%= if @strategy == nil do %>
        <%= if @show_strategy_form do %>
          <.add_strategy_form strategy_form_data={@strategy_form_data} />
        <% else %>
          <div class="flex justify-center items-center">
            <p class="text-slate-400 text-base">no active strategy</p>
          </div>
        <% end %>
      <% else %>
        <div>
          <p><strong>Strategy:</strong> <%= @strategy.name %></p>
          <p><strong>Interval:</strong> <%= @strategy.interval %></p>
          <p><strong>Currency pair:</strong> <%= @strategy.currency_pair %></p>
          <p><strong>TP:</strong> <%= @strategy.take_profit %> pips</p>
          <p><strong>SL:</strong> <%= @strategy.stop_loss %> pips</p>
          <p><strong>Distance:</strong> <%= @strategy.distance %> pips</p>
          <p><strong>Size:</strong> <%= @strategy.size %></p>
          <p><strong>Max orders:</strong> <%= @strategy.max_orders %></p>

          <div class="flex space-x-2 mt-2">
            <button class="bg-green-600 hover:bg-green-500 px-2 py-1 rounded text-sm">▶️ Start</button>
            <button class="bg-yellow-600 hover:bg-yellow-500 px-2 py-1 rounded text-sm">⏸ Stop</button>
            <button class="bg-blue-600 hover:bg-blue-500 px-2 py-1 rounded text-sm">🧹 Clean</button>
            <button class="bg-red-600 hover:bg-red-500 px-2 py-1 rounded text-sm">❌ Close</button>
          </div>
        </div>
      <% end %>
    """
  end
def add_strategy_form(assigns) do
  strategy_modules = Landbuyer.Strategies.Strategies.all()

  strategy_options =
    strategy_modules
    |> Enum.map(fn mod -> {mod.name(), Atom.to_string(mod.key())} end)

  assigns =
    assigns
    |> assign(:strategy_options, strategy_options)
    |> assign(:strategy_form_data, assigns.strategy_form_data)

  ~H"""
  <form phx-submit="create_strategy" class="p-4 bg-slate-700 rounded text-slate-200">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-x-6">
        <!-- Liste déroulante des stratégies -->
        <div>
          <label class="block text-sm">Strategy</label>
          <select name="strategy" class="w-full h-8 rounded bg-slate-200 text-slate-700 text-xs">
            <%= for {label, value} <- @strategy_options do %>
              <option value={value} selected={value == @strategy_form_data.strategy}><%= label %></option>
            <% end %>
          </select>
          <%= if @strategy_form_data.strategy_error do %>
            <div class="text-red text-xs mt-1"><%= @strategy_form_data.strategy_error %></div>
          <% end %>
        </div>
        <div>
          <label class="block text-sm">Interval</label>
          <.text_input name="interval" value={@strategy_form_data.interval} error={@strategy_form_data.interval_error} placeholder="ex: 15m" />
        </div>
        <div>
          <label class="block text-sm">Currency pair</label>
          <.text_input name="currency_pair" value={@strategy_form_data.currency_pair} error={@strategy_form_data.currency_pair_error} placeholder="ex: USDCHF" />
        </div>

        <!-- Colonne 2 -->
        <div>
          <label class="block text-sm">Decimals</label>
          <.text_input name="decimals" value={@strategy_form_data.decimals} error={@strategy_form_data.decimals_error} placeholder="ex: 3" />
        </div>
        <div>
          <label class="block text-sm">Take profit</label>
          <.text_input name="take_profit" value={@strategy_form_data.take_profit} error={@strategy_form_data.take_profit_error} placeholder="ex: 10" />
        </div>
        <div>
          <label class="block text-sm">Stop loss</label>
          <.text_input name="stop_loss" value={@strategy_form_data.stop_loss} error={@strategy_form_data.stop_loss_error} placeholder="ex: 10" />
        </div>

        <!-- Colonne 3 -->
        <div>
          <label class="block text-sm">Distance</label>
          <.text_input name="distance" value={@strategy_form_data.distance} error={@strategy_form_data.distance_error} placeholder="ex: 20" />
        </div>
        <div>
          <label class="block text-sm">Size</label>
          <.text_input name="size" value={@strategy_form_data.size} error={@strategy_form_data.size_error} placeholder="ex: 1000" />
        </div>
        <div>
          <label class="block text-sm">Max orders</label>
          <.text_input name="max_orders" value={@strategy_form_data.max_orders} error={@strategy_form_data.max_orders_error} placeholder="ex: 5" />
        </div>
      </div>

      <div class="flex justify-end mr-2">
        <button
          type="submit"
          class="grid place-content-center w-7 h-7 rounded bg-slate-800 hover:bg-slate-600 text-slate-200">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="green">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="5" d="M5 13l4 4L19 7" />
          </svg>
        </button>
      </div>

    </form>
  """
end
end
