defmodule Landbuyer2025Web.Live.DashboardLive do
  use Phoenix.LiveView
  import Landbuyer2025Web.Header
  import Landbuyer2025Web.Footer
  import Landbuyer2025Web.Button
  import Landbuyer2025Web.Live.Dashboard.Accounts
  alias Landbuyer2025.Accounts

  def mount(_params, _session, socket) do
    accounts = Landbuyer2025.Accounts.list_accounts()
    {:ok, assign(socket, accounts: accounts, selected_account: nil, show_form: false)}
  end

  def handle_event("add_account", _params, socket) do
    {:noreply, assign(socket, show_form: true)}
  end

  def handle_event("close_form", _params, socket) do
    {:noreply, assign(socket, show_form: false)}
  end

  def handle_event("create_account", params, socket) do
    IO.inspect(params, label: "PARAMS REÇUS")

    case Accounts.create_account(%{
      name: params["account_name"],
      id_oanda: params["id_oanda"],
      service: params["service"],
      token: params["token"]
    }) do
      {:ok, _account} ->
        # recharge la liste des comptes depuis la base
        accounts = Accounts.list_accounts()
        {:noreply, assign(socket, accounts: accounts, show_form: false)}

      {:error, changeset} ->
        IO.inspect(changeset, label: "ERREUR CHANGEMENT")
        {:noreply, assign(socket, show_form: true)}
    end
  end

  def handle_event("close_account", %{"id" => id}, socket) do
    id = String.to_integer(id)
    Landbuyer2025.Accounts.close_account(id)
    accounts = Landbuyer2025.Accounts.list_accounts()
    {:noreply, assign(socket, accounts: accounts)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col bg-slate-700">
      <.header />

      <main class="flex flex-1">
        <!-- Colonne gauche -->
        <div class="w-80 bg-slate-700 p-2 flex-col ml-8">
          <div
            phx-click="select_account"
            phx-value-id="overview"
            class={"p-4 m-2 rounded bg-slate-800 text-slate-200 hover:bg-slate-600 cursor-pointer"}>
            <div class="font-bold text-2xl">Overview</div>
            <div>NAV: 0.0</div>
          </div>

          <div class="flex items-center justify-between ml-4 mt-6 mr-2">
            <div class="text-slate-200 font-bold text-2xl">
              <%= if @show_form do %>
                Add account
              <% else %>
                Accounts
              <% end %>
            </div>

            <%= if @show_form do %>
              <.icon_button
                phx_click="close_form"
                d="M15 19l-7-7 7-7"
                bg_class="bg-slate-800"
                hover_class="hover:bg-slate-600"
              />
            <% else %>
              <.icon_button
                phx_click="add_account"
                d="M12 4v16m8-8H4"
                bg_class="bg-slate-800"
                hover_class="hover:bg-slate-600"
              />
            <% end %>
          </div>

          <%= if @show_form do %>
            <.add_account_form />
          <% else %>
            <%= for account <- @accounts do %>
              <.account account={account} selected_account={@selected_account} />
            <% end %>
          <% end %>
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
