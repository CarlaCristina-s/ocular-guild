defmodule OcularWeb.PlayerResetPasswordControllerTest do
  use OcularWeb.ConnCase, async: true

  alias Ocular.Accounts
  alias Ocular.Repo
  import Ocular.AccountsFixtures

  setup do
    %{player: player_fixture()}
  end

  describe "GET /players/reset_password" do
    test "renders the reset password page", %{conn: conn} do
      conn = get(conn, ~p"/players/reset_password")
      response = html_response(conn, 200)
      assert response =~ "Forgot your password?"
    end
  end

  describe "POST /players/reset_password" do
    @tag :capture_log
    test "sends a new reset password token", %{conn: conn, player: player} do
      conn =
        post(conn, ~p"/players/reset_password", %{
          "player" => %{"email" => player.email}
        })

      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Accounts.PlayerToken, player_id: player.id).context == "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      conn =
        post(conn, ~p"/players/reset_password", %{
          "player" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(Accounts.PlayerToken) == []
    end
  end

  describe "GET /players/reset_password/:token" do
    setup %{player: player} do
      token =
        extract_player_token(fn url ->
          Accounts.deliver_player_reset_password_instructions(player, url)
        end)

      %{token: token}
    end

    test "renders reset password", %{conn: conn, token: token} do
      conn = get(conn, ~p"/players/reset_password/#{token}")
      assert html_response(conn, 200) =~ "Reset password"
    end

    test "does not render reset password with invalid token", %{conn: conn} do
      conn = get(conn, ~p"/players/reset_password/oops")
      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "Reset password link is invalid or it has expired"
    end
  end

  describe "PUT /players/reset_password/:token" do
    setup %{player: player} do
      token =
        extract_player_token(fn url ->
          Accounts.deliver_player_reset_password_instructions(player, url)
        end)

      %{token: token}
    end

    test "resets password once", %{conn: conn, player: player, token: token} do
      conn =
        put(conn, ~p"/players/reset_password/#{token}", %{
          "player" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(conn) == ~p"/players/log_in"
      refute get_session(conn, :player_token)

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Password reset successfully"

      assert Accounts.get_player_by_email_and_password(player.email, "new valid password")
    end

    test "does not reset password on invalid data", %{conn: conn, token: token} do
      conn =
        put(conn, ~p"/players/reset_password/#{token}", %{
          "player" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      assert html_response(conn, 200) =~ "something went wrong"
    end

    test "does not reset password with invalid token", %{conn: conn} do
      conn = put(conn, ~p"/players/reset_password/oops")
      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "Reset password link is invalid or it has expired"
    end
  end
end
