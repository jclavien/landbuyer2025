defmodule Landbuyer2025Web.Live.DashboardLive do
  use Phoenix.LiveView
  import Landbuyer2025Web.Header
  import Landbuyer2025Web.Footer
  import Landbuyer2025Web.Button
  import Landbuyer2025Web.Live.Dashboard.Accounts
  import Landbuyer2025Web.Live.Dashboard

  alias Landbuyer2025.Accounts
  alias Landbuyer2025Web.FormData

  def mount(_params, _session, socket) do
    accounts = Landbuyer2025.Accounts.list_accounts()
    {:ok, assign(socket,
      accounts: accounts,
      selected_account: nil,
      show_form: false,
      form_data: %FormData{}
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
    {:noreply, assign(socket, selected_account: selected_account)}
  end

  def handle_event("add_account", _params, socket) do
    {:noreply, assign(socket,
      show_form: true,
      form_data: %FormData{}
    )}
  end

  def handle_event("close_form", _params, socket) do
    {:noreply, assign(socket,
        show_form: false,
        form_data: %FormData{}
      )}
  end

  def handle_event("create_account", params, socket) do
    account_name = String.trim(params["account_name"] || "")
    id_oanda = String.trim(params["id_oanda"] || "")
    service = String.trim(params["service"] || "")
    token = String.trim(params["token"] || "")

    errors = %{
      account_name_error: if(account_name == "", do: "required", else: nil),
      id_oanda_error: if(id_oanda == "", do: "required", else: nil),
      service_error: if(service == "", do: "required", else: nil),
      token_error: if(token == "", do: "required", else: nil)
    }

    has_errors = Enum.any?(Map.values(errors), & &1)

    form_data = %FormData{
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
        |> assign(:form_data, form_data)
        |> put_flash(:error, "Please fill in all required fields")

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
            |> assign(:form_data, %FormData{})
            |> put_flash(:info, "Account created successfully")

          {:noreply, socket}

        {:error, changeset} ->
          {:noreply,
            assign(socket, :show_form, true)
            |> put_flash(:error, "Error while creating account")}
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
        <div class="w-80 bg-slate-700 p-2 ml-8 mt-16">
        <.account_block
          account={:overview}
          selected_account={@selected_account}
        />

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
          <.add_account_form form_data={@form_data} />

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
      <div class="flex-1 p-4 text-slate-200">
        <%= if @selected_account do %>
          <.account_panel account={@selected_account} />
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
