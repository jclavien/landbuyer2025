defmodule Landbuyer2025Web.Footer do
  use Phoenix.Component

  def footer(assigns) do
    ~H"""
    <footer class="bg-slate-700 text-slate-200 text-sm p-2">
      <div class="flex justify-between items-center">
        <div>Prêt.</div>
        <div class="italic text-slate-500">Landbuyer 2025 v3.1</div>
      </div>
    </footer>
    """
  end
end
