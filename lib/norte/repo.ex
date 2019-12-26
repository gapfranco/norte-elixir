defmodule Norte.Repo do
  use Ecto.Repo,
    otp_app: :norte,
    adapter: Ecto.Adapters.Postgres
end
