defmodule Landbuyer2025Web.Live.Dashboard.Accounts do
  use Phoenix.Component

  def account(assigns) do
    ~H"""
    <div class={"p-4 m-2 rounded " <> if @is_overview, do: "bg-slate-800 text-slate-200", else: "bg-slate-600 text-slate-200"}>
      <h2 class="font-bold text-lg"><%= @name %></h2>
      <p>NAV: <%= @nav %></p>
    </div>
    """
  end
end
