defmodule Landbuyer2025Web.Live.DashboardLive do
    use Phoenix.LiveView

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

    def render(assigns) do
      ~H"""
      <h1>Bienvenue sur le Dashboard (via Live.Dashboard.DashboardLive)</h1>
      """
    end
  end
