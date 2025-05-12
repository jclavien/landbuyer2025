defmodule Landbuyer2025Web.Live.DashboardLive do
  use Phoenix.LiveView
  import Landbuyer2025Web.Header
  import Landbuyer2025Web.Footer
  import Landbuyer2025Web.Button
  import Landbuyer2025Web.Live.Dashboard.Accounts
  import Landbuyer2025Web.Live.Dashboard.Results
  import Landbuyer2025Web.Live.Dashboard.Graphs
  import Landbuyer2025Web.Live.Dashboard



  alias Landbuyer2025.Accounts
  alias Landbuyer2025Web.FormData
  alias Landbuyer2025Web.FormValidator


  def mount(_params, _session, socket) do
    accounts = Landbuyer2025.Accounts.list_accounts()
    {:ok, assign(socket,
      accounts: accounts,
      selected_account: nil,
      show_form: false,
      account_form_data: %FormData.Account{},
      strategy_form_data: %FormData.Strategy{}

    )}
  end

def handle_event("add_strategy", _params, socket) do
  {:noreply, assign(socket,
    show_strategy_form: true,
    strategy_form_data: %FormData.Strategy{}
  )}
end

def handle_event("create_strategy", _params, socket) do
  IO.puts("Création stratégie reçue !")
  {:noreply, socket}
end

def handle_event("close_strategy_form", _params, socket) do
  {:noreply, assign(socket,
    show_strategy_form: false,
    strategy_form_data: %FormData.Strategy{}
  )}
end

  def handle_event("select_account", %{"id" => id}, socket) do
    # On vérifie si c’est “overview” ou un ID numérique
    selected_account =
      if id == "overview" do
        nil
      else
        id = String.to_integer(id)
        Accounts.get_account!(id)
      end
      {:noreply,
      assign(socket,
        selected_account: selected_account,
        show_strategy_form: false,
        strategy_form_data: %FormData.Strategy{}
      )}

  end

  def handle_event("add_account", _params, socket) do
    {:noreply, assign(socket,
      show_form: true,
      account_form_data: %FormData.Account{}
    )}
  end

  def handle_event("close_form", _params, socket) do
    {:noreply, assign(socket,
        show_form: false,
        account_form_data: %FormData.Account{}
      )}
  end

  def handle_event("create_account", params, socket) do
    account_name = String.trim(params["account_name"] || "")
    id_oanda = String.trim(params["id_oanda"] || "")
    service = String.trim(params["service"] || "")
    token = String.trim(params["token"] || "")

    errors = FormValidator.validate_required_fields(params, ["account_name", "id_oanda", "service", "token"])

    has_errors = Enum.any?(Map.values(errors), & &1)

    account_form_data = %FormData.Account{
      account_name: account_name,
      id_oanda: id_oanda,
      service: service,
      token: token
    }
    |> Map.merge(errors)

    if has_errors do
      socket =
        socket
        |> assign(:show_form, true)
        |> assign(:account_form_data, account_form_data)
        |> put_flash(:error, "Please complete all required fields")

      {:noreply, socket}
    else
      case Accounts.create_account(%{
        name: account_name,
        id_oanda: id_oanda,
        service: service,
        token: token
      }) do
        {:ok, _account} ->
          accounts = Accounts.list_accounts()

          socket =
            socket
            |> assign(:accounts, accounts)
            |> assign(:show_form, false)
            |> assign(:account_form_data, %FormData.Account{})
            |> put_flash(:info, "Account created successfully")

          {:noreply, socket}

          {:error, changeset} ->
            {:noreply,
              assign(socket, :show_form, true)
              |> put_flash(:error, "Error while creating account: #{inspect(changeset.errors)}")}

      end
    end
  end

  def handle_event("close_account", %{"id" => id}, socket) do
    id = String.to_integer(id)
    Landbuyer2025.Accounts.close_account(id)
    accounts = Landbuyer2025.Accounts.list_accounts()

    socket =
      socket
      |> put_flash(:info, "Account #{id} closed successfully")

    {:noreply, assign(socket, accounts: accounts)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col bg-slate-700">
      <.header />

      <main class="flex flex-1">
        <!-- Colonne gauche -->
        <div class="bg-slate-700 p-2 ml-8 mt-16" style="width: 20rem">
        <.account_block
          account={:overview}
          selected_account={@selected_account}
        />

          <div class="flex items-center justify-between mt-14 ml-2 mr-2">
          <div class="text-slate-200 font-bold text-2xl ml-1">

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
          <.add_account_form account_form_data={@account_form_data} />

          <% else %>
          <%= for account <- @accounts do %>
            <.account_block
              account={account}
              selected_account={@selected_account}
              can_close={true}
            />
          <% end %>
          <% end %>
        </div>

        <!-- Contenu principal -->
      <div class="flex-1 text-slate-200">
        <%= if @selected_account do %>
        <.account_panel
          account={@selected_account}
          show_strategy_form={@show_strategy_form}
          strategy_form_data={@strategy_form_data}
        />
        <% else %>
          <.overview_panel />
        <% end %>
      </div>
      </main>

      <.footer flash={@flash} />
  </div>
  """
end
end
