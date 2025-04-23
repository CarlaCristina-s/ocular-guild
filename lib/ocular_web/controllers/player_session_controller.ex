defmodule OcularWeb.PlayerSessionController do
  use OcularWeb, :controller

  alias Ocular.Accounts
  alias OcularWeb.PlayerAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil, layout: false)
  end

  def create(conn, player_params) do
    %{"email" => email, "password" => password} = player_params

    if player = Accounts.get_player_by_email_and_password(email, password) do
      conn
      |> clear_flash()
      |> put_flash(:info, "Welcome back!")
      |> PlayerAuth.log_in_player(player, player_params)
    else
      conn
      |> put_flash(:failed_log_in, "Wrong e-mail or password!")
      |> render(:new, error_message: "Invalid email or password", layout: false)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> PlayerAuth.log_out_player()
  end
end
