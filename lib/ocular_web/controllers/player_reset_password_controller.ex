defmodule OcularWeb.PlayerResetPasswordController do
  use OcularWeb, :controller

  alias Ocular.Accounts

  plug :get_player_by_reset_password_token when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"player" => %{"email" => email}}) do
    if player = Accounts.get_player_by_email(email) do
      Accounts.deliver_player_reset_password_instructions(
        player,
        &url(~p"/players/reset_password/#{&1}")
      )
    end

    conn
    |> put_flash(
      :info,
      "If your email is in our system, you will receive instructions to reset your password shortly."
    )
    |> redirect(to: ~p"/")
  end

  def edit(conn, _params) do
    render(conn, :edit, changeset: Accounts.change_player_password(conn.assigns.player))
  end

  # Do not log in the player after reset password to avoid a
  # leaked token giving the player access to the account.
  def update(conn, %{"player" => player_params}) do
    case Accounts.reset_player_password(conn.assigns.player, player_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Password reset successfully.")
        |> redirect(to: ~p"/players/log_in")

      {:error, changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end

  defp get_player_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if player = Accounts.get_player_by_reset_password_token(token) do
      conn |> assign(:player, player) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
