defmodule OcularWeb.PageController do
  use OcularWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    current_player = conn.assigns[:current_player]

    if current_player do
      render(conn, :logged_in_home, current_player: current_player, layout: false)
    else
      render(conn, :home, current_player: current_player, layout: false)
    end
  end
end
