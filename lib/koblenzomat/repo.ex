defmodule Koblenzomat.Repo do
  use Ecto.Repo,
    otp_app: :koblenzomat,
    adapter: Ecto.Adapters.Postgres
end
