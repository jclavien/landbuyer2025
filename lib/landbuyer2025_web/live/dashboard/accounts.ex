defmodule Landbuyer2025Web.Live.Dashboard.Accounts do
  use Phoenix.Component
  import Landbuyer2025Web.Forms

  def account(assigns) do
    assigns =
      assign_new(assigns, :selected_account, fn -> nil end)

    bg_class =
      if assigns.selected_account == assigns.account.id do
        "bg-slate-800"
      else
        "bg-slate-600"
      end

    assigns = assign(assigns, :bg_class, bg_class)

    ~H"""
    <div
      phx-click="select_account"
      phx-value-id={@account.id}
      class={"relative w-72 p-2 m-2 rounded #{@bg_class} text-slate-200 hover:bg-slate-800 cursor-pointer"}>

        <!-- bouton fermeture en haut à gauche en position absolue -->
        <button
          phx-click="close_account"
          phx-value-id={@account.id}
          phx-stop-propagation
          class="absolute top-3 left-3 grid place-content-center w-4 h-4 rounded bg-slate-800 hover:bg-slate-600">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 text-red" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <!-- contenu décalé vers la droite -->
        <div class="ml-9">
          <div class="font-bold"><%= @account.name %></div>
          <div class="text-slate-400 italic text-sm">ID: <%= @account.display_id || "no id yet" %></div>
          <div>NAV: 0.0</div>
        </div>
      </div>
    """
  end

  def account_block(assigns) do
    assigns =
      assigns
      |> assign_new(:selected_account, fn -> nil end)
      |> assign_new(:can_close, fn -> false end)
      |> assign_new(:account_title, fn -> if assigns.account == :overview, do: "Overview", else: assigns.account.name end)
      |> assign_new(:nav, fn -> 0.0 end)

    is_selected =
      if assigns.account == :overview do
        assigns.selected_account == nil
      else
        assigns.selected_account && assigns.selected_account.id == assigns.account.id
      end

    bg_class =
      if is_selected do
        "bg-slate-800 rounded rounded-r-none -mr-2"
      else
        "bg-slate-600 rounded"
      end

    ~H"""
    <div
      phx-click="select_account"
      phx-value-id={if @account == :overview, do: "overview", else: @account.id}
      class={"relative w-72 p-2 m-2 #{bg_class} text-slate-200 hover:scale-105 transition-transform duration-300 cursor-pointer"}>

      <%= if @can_close do %>
        <!-- bouton fermeture (accounts uniquement) -->
        <button
          phx-click="close_account"
          phx-value-id={@account.id}
          phx-stop-propagation
          class="absolute top-3 left-3 grid place-content-center w-4 h-4 rounded bg-slate-800 hover:bg-slate-600">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 text-red" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      <% end %>

      <!-- contenu bloc -->
      <div class={"#{if @can_close, do: "ml-9", else: ""}"}>
        <div class="font-bold text-xl"><%= @account_title %></div>
        <div class="text-slate-400 italic text-xs">
          <%= if @account == :overview, do: "", else: "ID: #{@account.display_id || "no id yet"}" %>
        </div>
        <div class="font-bold">NAV: <%= @nav %></div>
      </div>
    </div>
    """
  end

  def add_account_form(assigns) do
    form_data = assigns.form_data

    ~H"""
    <form phx-submit="create_account" class="flex flex-col space-y-4 p-4 bg-slate-700 rounded text-slate-200">
      <div>
        <label class="block text-sm text-slate-200">Account Name</label>
        <.text_input name="account_name" value={form_data.account_name} placeholder="eg. LB USDCHF" error={form_data.account_name_error} />
      </div>
      <div>
        <label class="block text-sm text-slate-200">ID Oanda</label>
        <.text_input name="id_oanda" value={form_data.id_oanda} placeholder="..." error={form_data.id_oanda_error} />
      </div>
      <div>
        <label class="block text-sm text-slate-200">Service</label>
        <.text_input name="service" value={form_data.service} placeholder="..." error={form_data.service_error} />
      </div>
      <div>
        <label class="block text-sm text-slate-200">Token</label>
        <.text_input name="token" value={form_data.token} placeholder="..." error={form_data.token_error} />
      </div>
      <div class="flex justify-end">
        <button
          type="submit"
          class="grid place-content-center w-7 h-7 rounded bg-slate-800 hover:bg-slate-600 text-slate-200">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path d="M12 4v16m8-8H4" stroke-linecap="round" stroke-linejoin="round" stroke-width="3" />
          </svg>
        </button>
      </div>
    </form>
    """
  end
end
