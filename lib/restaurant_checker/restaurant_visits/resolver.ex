defmodule RestaurantChecker.RestaurantVisits.Resolver do
  alias RestaurantChecker.RestaurantVisits.RestaurantVisit
  alias RestaurantChecker.Repo

  def batch_insert(restaurant_visits) do
    restaurant_visits
    |> Enum.chunk_every(1000)
    |> Enum.map(& Repo.insert_all(RestaurantVisit, &1))
  end
end
