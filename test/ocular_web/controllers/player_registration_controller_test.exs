defmodule OcularWeb.PlayerRegistrationControllerTest do
  use OcularWeb.ConnCase, async: true

  import Ocular.AccountsFixtures

  describe "GET /players/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, ~p"/players/register")
      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ ~p"/players/log_in"
      assert response =~ ~p"/players/register"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_player(player_fixture()) |> get(~p"/players/register")

      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "POST /players/register" do
    @tag :capture_log
    test "creates account and logs the player in", %{conn: conn} do
      email = unique_player_email()

      conn =
        post(conn, ~p"/players/register", %{
          "player" => valid_player_attributes(email: email)
        })

      assert get_session(conn, :player_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ ~p"/players/settings"
      assert response =~ ~p"/players/log_out"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, ~p"/players/register", %{
          "player" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
