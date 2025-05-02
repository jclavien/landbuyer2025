defmodule Landbuyer2025Web.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use Landbuyer2025Web, :controller` and
  `use Landbuyer2025Web, :live_view`.
  """
  use Landbuyer2025Web, :html

   # Ici on peut définir des composants réutilisables pour le layout
  embed_templates "layouts/*"
  def dashboard_header(assigns) do
    ~H"""
    <header class="bg-bg1 text-slate-200 p-4">
      <h1>Landbuyer 2025 Dashboard</h1>
    </header>
    """
  end
end
