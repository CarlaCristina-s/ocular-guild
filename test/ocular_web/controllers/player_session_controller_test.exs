defmodule OcularWeb.PlayerSessionControllerTest do
  use OcularWeb.ConnCase, async: true

  import Ocular.AccountsFixtures

  setup do
    %{player: player_fixture()}
  end

  describe "GET /players/log_in" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, ~p"/players/log_in")
      response = html_response(conn, 200)
      assert response =~ "Log in"
      assert response =~ ~p"/players/register"
      assert response =~ "Forgot your password?"
    end

    test "redirects if already logged in", %{conn: conn, player: player} do
      conn = conn |> log_in_player(player) |> get(~p"/players/log_in")
      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "POST /players/log_in" do
    test "logs the player in", %{conn: conn, player: player} do
      conn =
        post(conn, ~p"/players/log_in", %{
          "player" => %{"email" => player.email, "password" => valid_player_password()}
        })

      assert get_session(conn, :player_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ player.email
      assert response =~ ~p"/players/settings"
      assert response =~ ~p"/players/log_out"
    end

    test "logs the player in with remember me", %{conn: conn, player: player} do
      conn =
        post(conn, ~p"/players/log_in", %{
          "player" => %{
            "email" => player.email,
            "password" => valid_player_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_ocular_web_player_remember_me"]
      assert redirected_to(conn) == ~p"/"
    end

    test "logs the player in with return to", %{conn: conn, player: player} do
      conn =
        conn
        |> init_test_session(player_return_to: "/foo/bar")
        |> post(~p"/players/log_in", %{
          "player" => %{
            "email" => player.email,
            "password" => valid_player_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Welcome back!"
    end

    test "emits error message with invalid credentials", %{conn: conn, player: player} do
      conn =
        post(conn, ~p"/players/log_in", %{
          "player" => %{"email" => player.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "Log in"
      assert response =~ "Invalid email or password"
    end
  end

  describe "DELETE /players/log_out" do
    test "logs the player out", %{conn: conn, player: player} do
      conn = conn |> log_in_player(player) |> delete(~p"/players/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :player_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the player is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/players/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :player_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end
  end
end
