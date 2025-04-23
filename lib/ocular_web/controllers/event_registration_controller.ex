defmodule OcularWeb.EventRegistrationController do
  use OcularWeb, :controller

  require Logger

  alias Ocular.Events

  def index(conn, _params), do: render(conn, "index.html", layout: false)

  def new(conn, _params), do: render(conn, "new.html", layout: false)

  def show(conn, %{"event_id" => event_id}) do
    event = Events.get_event!(event_id)
    builds = Events.list_builds(event_id)

    render(conn, "show.html", event: event, builds: builds, layout: false)
  end

  def create(conn, event_params = %{"regeared?" => regeared?}) do
    regeared? = if regeared? == "true", do: true, else: false

    {:ok, time} =
      event_params["time"]
      |> String.replace("T", " ")
      |> Kernel.<>(":00")
      |> NaiveDateTime.from_iso8601()

    event_params = Map.put(event_params, "regeared?", regeared?) |> Map.put("time", time)

    Logger.info("Creating event params: `#{inspect(event_params)}`")

    case Events.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "event created successfully.")
        |> redirect(to: ~p"/events/#{event.id}/edit")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"event_id" => event_id}) do
    event = Events.get_event!(event_id)
    builds = Events.list_builds(event_id)

    render(conn, "edit.html", event: event, builds: builds, event_id: event_id, layout: false)
  end

  def update(conn, params) do
    event_id = Map.get(params, "event_id")
    event = Events.get_event!(event_id)
    {:ok, _build} = Events.create_build(params)
    builds = Events.list_builds(event_id)

    render(conn, "edit.html", event: event, builds: builds, event_id: event_id, layout: false)
  end

  def update_build(conn, %{"build_id" => build_id}) do
    player = conn.assigns[:current_player]

    build = Events.get_build!(build_id)
    {:ok, _updated_build} = Events.update_build(build, %{player_id: player.id})

    event = Events.get_event!(build.event_id)
    builds = Events.list_builds(build.event_id)
    render(conn, "show.html", event: event, builds: builds, layout: false)
  end

  def leave_build(conn, %{"build_id" => build_id}) do
    build = Events.get_build!(build_id)
    {:ok, _updated_build} = Events.update_build(build, %{player_id: nil})

    event = Events.get_event!(build.event_id)
    builds = Events.list_builds(build.event_id)
    render(conn, "show.html", event: event, builds: builds, layout: false)
  end
end
