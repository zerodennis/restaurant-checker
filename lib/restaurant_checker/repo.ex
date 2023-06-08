defmodule RestaurantChecker.Repo do
  use Ecto.Repo,
    otp_app: :restaurant_checker,
    adapter: Ecto.Adapters.Postgres
end
