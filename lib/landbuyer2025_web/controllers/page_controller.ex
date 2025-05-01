defmodule Landbuyer2025Web.PageController do
  use Landbuyer2025Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
