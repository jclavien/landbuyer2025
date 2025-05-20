defmodule Landbuyer2025Web.Live.DashboardLiveBackup do
  use Phoenix.LiveView
  import Landbuyer2025Web.Header
  import Landbuyer2025Web.Footer
  import Landbuyer2025Web.Button
  import Landbuyer2025Web.Live.Dashboard.Accounts
  # import Landbuyer2025Web.Live.Dashboard.Results
  # import Landbuyer2025Web.Live.Dashboard.Graphs
  import Landbuyer2025Web.Live.DashboardBackup

  alias Landbuyer2025.Accounts
  alias Landbuyer2025Web.FormData
  alias Landbuyer2025Web.FormValidator

  def mount(_params, _session, socket) do
    accounts = Landbuyer2025.Accounts.list_accounts()

    {:ok,
     assign(socket,
       accounts: accounts,
       selected_account: nil,
       show_form: false,
       account_form_data: %FormData.Account{},
       strategy_form_data: %FormData.Strategy{},
       edit_mode: false
     )}
  end

  defp safe_to_float(str) do
    case Float.parse(str) do
      {val, _} -> val
      :error -> 0.0
    end
  end

  defp safe_to_int(str) do
    case Integer.parse(str) do
      {val, _} -> val
      :error -> 0
    end
  end

  def handle_event("create_strategy", params, socket) do
    # Nettoyage et conversion des paramètres
    strategy_name = String.trim(params["strategy_name"] || "")
    interval = String.trim(params["interval"] || "")
    currency_pair = String.trim(params["currency_pair"] || "")
    decimals = String.trim(params["decimals"] || "")
    take_profit = String.trim(params["take_profit"] || "")
    stop_loss = String.trim(params["stop_loss"] || "")
    distance = String.trim(params["distance"] || "")
    order_size = String.trim(params["order_size"] || "")
    max_orders = String.trim(params["max_orders"] || "")
    direction = String.trim(params["direction"] || "")

    # Validation simplifiée : vérifie que les champs essentiels sont présents
    required_errors =
      FormValidator.validate_required_fields(params, [
        "strategy_name",
        "interval",
        "currency_pair",
        "decimals",
        "take_profit",
        "stop_loss",
        "distance",
        "order_size",
        "max_orders",
        "direction"
      ])

    format_errors =
      %{}
      |> Map.merge(FormValidator.validate_currency_pair_format(params, "currency_pair"))
      |> Map.merge(FormValidator.validate_integer_format(params, "interval"))
      |> Map.merge(FormValidator.validate_integer_format(params, "decimals"))
      |> Map.merge(FormValidator.validate_float_format(params, "take_profit"))
      |> Map.merge(FormValidator.validate_float_format(params, "stop_loss"))
      |> Map.merge(FormValidator.validate_float_format(params, "distance"))
      |> Map.merge(FormValidator.validate_float_format(params, "order_size"))
      |> Map.merge(FormValidator.validate_integer_format(params, "max_orders"))
      |> Map.merge(FormValidator.validate_strategy_exists(params))

    errors = Map.merge(required_errors, format_errors)
    has_errors = Enum.any?(Map.values(errors), & &1)

    strategy_form_data =
      %Landbuyer2025Web.FormData.Strategy{
        account_id: socket.assigns.selected_account.id,
        strategy_name: strategy_name,
        interval: interval,
        currency_pair: currency_pair,
        decimals: decimals,
        take_profit: take_profit,
        stop_loss: stop_loss,
        distance: distance,
        order_size: order_size,
        max_orders: max_orders,
        direction: direction
      }
      |> Map.merge(errors)

    if has_errors do
      socket =
        socket
        |> assign(:show_strategy_form, true)
        |> assign(:strategy_form_data, strategy_form_data)
        |> put_flash(:error, "Please fix the errors in the form before submitting")

      {:noreply, socket}
    else
      case Landbuyer2025.Strategies.create_strategy(%{
             account_id: socket.assigns.selected_account.id,
             strategy_name: strategy_name,
             interval: safe_to_int(interval),
             currency_pair: currency_pair,
             decimals: safe_to_int(decimals),
             take_profit: safe_to_float(take_profit),
             stop_loss: safe_to_float(stop_loss),
             distance: safe_to_float(distance),
             order_size: safe_to_float(order_size),
             max_orders: safe_to_int(max_orders),
             direction: direction
           }) do
        {:ok, created_strategy} ->
          full_strategy = Landbuyer2025.Strategies.get_strategy!(created_strategy.id)

          # 🔹 Enregistre un snapshot complet dès la création
          Landbuyer2025.Strategies.snapshot_strategy(full_strategy)

          socket =
            socket
            |> assign(:show_strategy_form, false)
            |> assign(:strategy_form_data, %Landbuyer2025Web.FormData.Strategy{})
            |> assign(:strategy, full_strategy)
            |> put_flash(:info, "Strategy created successfully")

          {:noreply, socket}

        {:error, changeset} ->
          {:noreply,
           socket
           |> assign(:show_strategy_form, true)
           |> put_flash(:error, "Error while creating strategy: #{inspect(changeset.errors)}")}
      end
    end
  end

  def handle_event("add_strategy", _params, socket) do
    selected_account_id = socket.assigns.selected_account.id

    strategy_form_data =
      %FormData.Strategy{}
      |> Map.put(:account_id, selected_account_id)

    {:noreply,
     socket
     |> assign(:show_strategy_form, true)
     |> assign(:strategy_form_data, strategy_form_data)}
  end

  def handle_event("start_strategy", _params, socket) do
    strategy = socket.assigns.strategy

    # Mettre à jour le statut en base
    {:ok, updated_strategy} =
      Landbuyer2025.Strategies.update_strategy(strategy, %{status: "started"})

    # Enregistrer un snapshot complet de la stratégie
    Landbuyer2025.Strategies.snapshot_strategy(updated_strategy)

    # Réassigner la stratégie mise à jour
    {:noreply, assign(socket, :strategy, updated_strategy)}
  end

  def handle_event("stop_strategy", _params, socket) do
    strategy = socket.assigns.strategy

    {:ok, updated_strategy} =
      Landbuyer2025.Strategies.update_strategy(strategy, %{status: "stopped"})

    # Enregistrer un snapshot complet de la stratégie
    Landbuyer2025.Strategies.snapshot_strategy(updated_strategy)

    {:noreply, assign(socket, :strategy, updated_strategy)}
  end

  def handle_event("edit_strategy", _params, socket) do
    strategy = socket.assigns.strategy

    if strategy.status == "started" do
      socket =
        socket
        |> put_flash(:error, "Stop the strategy before editing its parameters")

      {:noreply, socket}
    else
      form_data = %FormData.Strategy{
        strategy_name: strategy.strategy_name,
        interval: strategy.interval,
        currency_pair: strategy.currency_pair,
        decimals: strategy.decimals,
        take_profit: strategy.take_profit,
        stop_loss: strategy.stop_loss,
        distance: strategy.distance,
        order_size: strategy.order_size,
        max_orders: strategy.max_orders,
        direction: strategy.direction
      }

      socket =
        socket
        |> assign(:strategy_form_data, form_data)
        |> assign(:show_strategy_form, true)
        |> assign(:edit_mode, true)

      {:noreply, socket}
    end
  end

  def handle_event("update_strategy", params, socket) do
    strategy = socket.assigns.strategy

    # Récupération des valeurs brutes
    take_profit = String.trim(params["take_profit"] || "")
    stop_loss = String.trim(params["stop_loss"] || "")
    distance = String.trim(params["distance"] || "")
    order_size = String.trim(params["order_size"] || "")
    max_orders = String.trim(params["max_orders"] || "")

    # Validation manuelle
    format_errors =
      %{}
      |> Map.merge(FormValidator.validate_float_format(params, "take_profit"))
      |> Map.merge(FormValidator.validate_float_format(params, "stop_loss"))
      |> Map.merge(FormValidator.validate_float_format(params, "distance"))
      |> Map.merge(FormValidator.validate_float_format(params, "order_size"))
      |> Map.merge(FormValidator.validate_integer_format(params, "max_orders"))

    has_errors = Enum.any?(Map.values(format_errors), & &1)

    updated_data =
      %FormData.Strategy{
        take_profit: take_profit,
        stop_loss: stop_loss,
        distance: distance,
        order_size: order_size,
        max_orders: max_orders
      }
      |> Map.merge(format_errors)

    if has_errors do
      socket =
        socket
        |> assign(:strategy_form_data, updated_data)
        |> put_flash(:error, "Please fix the errors in the form before updating.")

      {:noreply, socket}
    else
      # Mise à jour en base
      case Landbuyer2025.Strategies.update_strategy(strategy, %{
             take_profit: safe_to_float(take_profit),
             stop_loss: safe_to_float(stop_loss),
             distance: safe_to_float(distance),
             order_size: safe_to_float(order_size),
             max_orders: safe_to_int(max_orders)
           }) do
        {:ok, updated_strategy} ->
          # Création d’un snapshot après mise à jour
          {:ok, _snapshot} = Landbuyer2025.Strategies.snapshot_strategy(updated_strategy)

          socket =
            socket
            |> assign(:strategy, updated_strategy)
            |> assign(:strategy_form_data, %FormData.Strategy{})
            |> assign(:show_strategy_form, false)
            |> assign(:edit_mode, false)
            |> put_flash(:info, "Strategy updated successfully")

          {:noreply, socket}

        {:error, changeset} ->
          socket =
            socket
            |> assign(:strategy_form_data, updated_data)
            |> put_flash(:error, "Update failed: #{inspect(changeset.errors)}")

          {:noreply, socket}
      end
    end
  end

  def handle_event("close_strategy_form", _params, socket) do
    {:noreply,
     assign(socket,
       show_strategy_form: false,
       strategy_form_data: %FormData.Strategy{},
       edit_mode: false
     )}
  end

  def handle_event("add_account", _params, socket) do
    {:noreply,
     assign(socket,
       show_form: true,
       account_form_data: %FormData.Account{}
     )}
  end

  def handle_event("select_account", %{"id" => id}, socket) do
    # Si l'utilisateur sélectionne "overview", on vide le compte et la stratégie
    {selected_account, strategy} =
      if id == "overview" do
        {nil, nil}
      else
        account_id = String.to_integer(id)
        selected = Accounts.get_account!(account_id)
        strat = Landbuyer2025.Strategies.get_latest_strategy_for_account(account_id)
        {selected, strat}
      end

    {:noreply,
     assign(socket,
       selected_account: selected_account,
       strategy: strategy,
       show_strategy_form: false,
       strategy_form_data: %FormData.Strategy{}
     )}
  end

  def handle_event("close_form", _params, socket) do
    {:noreply,
     assign(socket,
       show_form: false,
       account_form_data: %FormData.Account{}
     )}
  end

  def handle_event("create_account", params, socket) do
    account_name = String.trim(params["account_name"] || "")
    id_oanda = String.trim(params["id_oanda"] || "")
    service = String.trim(params["service"] || "")
    token = String.trim(params["token"] || "")

    errors =
      FormValidator.validate_required_fields(params, [
        "account_name",
        "id_oanda",
        "service",
        "token"
      ])

    has_errors = Enum.any?(Map.values(errors), & &1)

    account_form_data =
      %FormData.Account{
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
          <.account_block account={:overview} selected_account={@selected_account} />
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
              <.account_block account={account} selected_account={@selected_account} can_close={true} />
            <% end %>
          <% end %>
        </div>
        
    <!-- Contenu principal -->
        <div class="flex-1 text-slate-200">
          <%= if @selected_account do %>
            <.account_panel
              account={@selected_account}
              strategy={@strategy}
              show_strategy_form={@show_strategy_form}
              strategy_form_data={@strategy_form_data}
              edit_mode={@edit_mode}
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
