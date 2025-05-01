defmodule Landbuyer2025Web.ErrorJSONTest do
  use Landbuyer2025Web.ConnCase, async: true

  test "renders 404" do
    assert Landbuyer2025Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Landbuyer2025Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
