defmodule OcularWeb.PlayerRegistrationController do
  use OcularWeb, :controller

  import Ecto.Query

  alias Ocular.Accounts
  alias OcularWeb.PlayerAuth

  def index(conn, _params) do
    render(conn, "index.html", layout: false)
  end

  def authorize(conn, params) do
    authorized? = if params["authorize"] == "true", do: true, else: false
    player_id = params["player_id"]

    {1, nil} =
      from(p in Ocular.Accounts.Player, where: p.id == ^player_id)
      |> Ocular.Repo.update_all(set: [authorized?: authorized?])

    render(conn, "index.html", layout: false)
  end

  def new(conn, _params) do
    render(conn, "new.html", layout: false)
  end

  def create(conn, player_params) do
    case Accounts.register_player(player_params) do
      {:ok, player} ->
        # {:ok, _} =
        #   Accounts.deliver_player_confirmation_instructions(
        #     player,
        #     &url(~p"/players/confirm/#{&1}")
        #   )

        conn
        |> put_flash(:info, "Player created successfully.")
        |> PlayerAuth.log_in_player(player)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
