defmodule Landbuyer2025Web.Live.Dashboard.Accounts do
  use Phoenix.Component

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
      class={"p-4 m-2 rounded #{@bg_class} text-slate-200 hover:bg-slate-800 cursor-pointer"}>
      <div class="flex items-center justify-between">
      <div class="font-bold"><%= @account.name %></div>
      <button
        phx-click="close_account"
        phx-value-id={@account.id}
        class="grid place-content-center w-5 h-5 rounded bg-slate-800 hover:bg-slate-600">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-red" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
      </div>
      <div class="text-slate-400 italic text-sm"><%= @account.display_id || "no id yet" %></div>
      <div>NAV: 0.0</div>
    </div>
    """
  end

  def add_account_form(assigns) do
    ~H"""
    <form phx-submit="create_account" class="flex flex-col space-y-4 p-4 bg-slate-700 rounded text-slate-200">
      <div>
        <label class="block text-sm text-slate-200">Account Name</label>
        <input type="text" name="account_name" class="w-full p-2 rounded bg-slate-200 text-slate-700"/>
      </div>
      <div>
        <label class="block text-sm text-slate-200">ID Oanda</label>
        <input type="text" name="id_oanda" class="w-full p-2 rounded bg-slate-200 text-slate-700"/>
      </div>
      <div>
        <label class="block text-sm text-slate-200">Service</label>
        <input type="text" name="service" class="w-full p-2 rounded bg-slate-200 text-slate-700"/>
      </div>
      <div>
        <label class="block text-sm text-slate-200">Token</label>
        <input type="text" name="token" class="w-full p-2 rounded bg-slate-200 text-slate-700"/>
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
