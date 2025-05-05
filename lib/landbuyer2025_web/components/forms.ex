defmodule Landbuyer2025Web.Forms do
  use Phoenix.Component


  def account_form(assigns) do
    assigns =
      assign_new(assigns, :changeset, fn ->
        Ecto.Changeset.change(%{})
      end)

    ~H"""
    <.form
      for={@changeset}
      phx-submit="save_account"
      class="flex flex-col space-y-4"
    >
      <div>
        <label class="block text-sm text-slate-200">Account Name</label>
        <input type="text" name="account[name]" class="w-full p-2 rounded bg-slate-800 text-slate-200"/>
      </div>
      <div>
        <label class="block text-sm text-slate-200">Oanda ID</label>
        <input type="text" name="account[oanda_id]" class="w-full p-2 rounded bg-slate-800 text-slate-200"/>
      </div>
      <div>
        <label class="block text-sm text-slate-200">Service</label>
        <input type="text" name="account[service]" class="w-full p-2 rounded bg-slate-800 text-slate-200"/>
      </div>
      <div>
        <label class="block text-sm text-slate-200">Token</label>
        <input type="text" name="account[token]" class="w-full p-2 rounded bg-slate-800 text-slate-200"/>
      </div>

      </.form>
    """
  end
end
