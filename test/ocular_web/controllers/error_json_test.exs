defmodule OcularWeb.ErrorJSONTest do
  use OcularWeb.ConnCase, async: true

  test "renders 404" do
    assert OcularWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert OcularWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
