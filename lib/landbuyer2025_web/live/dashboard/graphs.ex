defmodule Landbuyer2025Web.Live.Dashboard.Graphs do
  use Phoenix.Component

  def main_graph(assigns) do
    ~H"""
    <div class="flex justify-between items-center mb-2 ml-2">
        <h2 class="text-xl font-bold">Graph</h2></div>
      <div class="h-48 bg-slate-600 rounded flex items-center justify-center">
        <p class="text-slate-400">Graph placeholder</p>
      </div>

    """
  end

  def sub_graphs(assigns) do
    ~H"""
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div class="p-4 bg-slate-700 rounded">
        <h3 class="font-bold mb-2">Sub Graph 1</h3>
        <div class="h-32 bg-slate-600 rounded flex items-center justify-center">
          <p class="text-slate-400">Placeholder</p>
        </div>
      </div>
      <div class="p-4 bg-slate-700 rounded">
        <h3 class="font-bold mb-2">Sub Graph 2</h3>
        <div class="h-32 bg-slate-600 rounded flex items-center justify-center">
          <p class="text-slate-400">Placeholder</p>
        </div>
      </div>
    </div>
    """
  end
end
