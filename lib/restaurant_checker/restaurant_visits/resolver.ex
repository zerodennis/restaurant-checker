defmodule RestaurantChecker.RestaurantVisits.Resolver do
  alias RestaurantChecker.RestaurantVisits.RestaurantVisit
  alias RestaurantChecker.Repo
  alias RestaurantChecker.RestaurantVisits.Queries

  def batch_insert(restaurant_visits) do
    restaurant_visits
    |> Enum.chunk_every(1000)
    |> Enum.map(&Repo.insert_all(RestaurantVisit, &1))
  end

  def customers_by_restaurant(params \\ %{}) do
    params
    |> Queries.get_visitors_by_restaurant_name()
    |> Repo.aggregate(:count, :first_name)
  end

  def earnings_by_restaurant(params \\ %{}) do
    params
    |> Queries.get_earnings_by_restaurant_name()
    |> Repo.one()
  end

  def most_popular_dishes() do
    Repo.query(Queries.most_popular_dishes(), [])
  end

  def most_profitable_dishes() do
    Repo.query(Queries.most_profitable_dishes(), [])
  end

  def most_frequent_visitors_per_store do
    Repo.query(Queries.most_frequent_visitor_per_store(), [])
  end

  def most_avid_visitor do
    Repo.query(Queries.most_visited_stores(), [])
  end
end
