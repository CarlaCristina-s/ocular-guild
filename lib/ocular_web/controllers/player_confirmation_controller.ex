defmodule OcularWeb.PlayerConfirmationController do
  use OcularWeb, :controller

  alias Ocular.Accounts

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"player" => %{"email" => email}}) do
    if player = Accounts.get_player_by_email(email) do
      Accounts.deliver_player_confirmation_instructions(
        player,
        &url(~p"/players/confirm/#{&1}")
      )
    end

    conn
    |> put_flash(
      :info,
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."
    )
    |> redirect(to: ~p"/")
  end

  def edit(conn, %{"token" => token}) do
    render(conn, :edit, token: token)
  end

  # Do not log in the player after confirmation to avoid a
  # leaked token giving the player access to the account.
  def update(conn, %{"token" => token}) do
    case Accounts.confirm_player(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Player confirmed successfully.")
        |> redirect(to: ~p"/")

      :error ->
        # If there is a current player and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the player themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_player: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: ~p"/")

          %{} ->
            conn
            |> put_flash(:error, "Player confirmation link is invalid or it has expired.")
            |> redirect(to: ~p"/")
        end
    end
  end
end
