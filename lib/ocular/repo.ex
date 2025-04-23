defmodule Ocular.Repo do
  use Ecto.Repo,
    otp_app: :ocular,
    adapter: Ecto.Adapters.Postgres
end
