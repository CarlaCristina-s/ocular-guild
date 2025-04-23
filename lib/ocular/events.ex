defmodule Ocular.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Ocular.Repo

  alias Ocular.Events.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  alias Ocular.Events.Build

  @doc """
  Returns the list of builds.

  ## Examples

      iex> list_builds()
      [%Build{}, ...]

  """
  def list_builds(event_id) do
    Build
    |> where([build], build.event_id == ^event_id)
    |> Repo.all()
  end

  @doc """
  Gets a single build.

  Raises `Ecto.NoResultsError` if the Build does not exist.

  ## Examples

      iex> get_build!(123)
      %Build{}

      iex> get_build!(456)
      ** (Ecto.NoResultsError)

  """
  def get_build!(id), do: Repo.get!(Build, id)

  @doc """
  Creates a build.

  ## Examples

      iex> create_build(%{field: value})
      {:ok, %Build{}}

      iex> create_build(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_build(attrs \\ %{}) do
    %Build{}
    |> Build.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a build.

  ## Examples

      iex> update_build(build, %{field: new_value})
      {:ok, %Build{}}

      iex> update_build(build, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_build(%Build{} = build, attrs) do
    build
    |> Build.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a build.

  ## Examples

      iex> delete_build(build)
      {:ok, %Build{}}

      iex> delete_build(build)
      {:error, %Ecto.Changeset{}}

  """
  def delete_build(%Build{} = build) do
    Repo.delete(build)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking build changes.

  ## Examples

      iex> change_build(build)
      %Ecto.Changeset{data: %Build{}}

  """
  def change_build(%Build{} = build, attrs \\ %{}) do
    Build.changeset(build, attrs)
  end

  def get_showable_events do
    query = from e in Event, where: e.time > datetime_add(^NaiveDateTime.utc_now(), -2, "hour")

    Repo.all(query)
  end

  def parse_time(time) do
    time = NaiveDateTime.to_string(time)

    String.slice(time, 0, 10) <> " " <> String.slice(time, 11, 5) <> "UTC"
  end
end
