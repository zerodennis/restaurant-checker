defmodule RestaurantChecker.RestaurantVisits.Resolver do
  @moduledoc """
    Resolver module for the RestaurantVisit model.

    All retrievals using the Repo module, and
    related transformations (if necessary) go here.
  """

  alias RestaurantChecker.RestaurantVisits.RestaurantVisit
  alias RestaurantChecker.Repo
  alias RestaurantChecker.RestaurantVisits.Queries

  @doc """
    Inserts entries into the restaurant_visit table
    by separating them into 1000-entry chunks.

    Returns {:ok, entries}
  """
  def batch_insert(restaurant_visits) do
    restaurant_visits
    |> Enum.chunk_every(1000)
    |> Enum.map(&Repo.insert_all(RestaurantVisit, &1))
  end

  @doc """
    Gets the amount of visitors to a restaurant

    Returns integer
  """
  def customers_by_restaurant(params \\ %{}) do
    params
    |> Queries.get_visits_by_restaurant_name()
    |> Repo.aggregate(:count, :first_name)
  end

  @doc """
    Gets the amount of profit earned by a restaurant

    Returns decimal
  """
  def earnings_by_restaurant(params \\ %{}) do
    params
    |> Queries.get_earnings_by_restaurant_name()
    |> Repo.one()
  end

  @doc """
    Gets the most popular dishes per restaurant.

    Returns
    {:ok, %{rows: rows}}

    Where rows is a list of tuples containing:

    [{restaurant_name, food_name, food_count}
      ...
     {restaurant_name, food_name, food_count}
    ]
  """
  def most_popular_dishes() do
    Repo.query(Queries.most_popular_dishes(), [])
  end

  @doc """
    Gets the most profitable dishes per restaurant

    Returns
    {:ok, %{rows: rows}}

    Where rows is a list of tuples containing:

    [
      {restaurant_name, food_name, total_profit},
      ...
      {restaurant_name, food_name, total_profit}
    ]
  """
  def most_profitable_dishes() do
    Repo.query(Queries.most_profitable_dishes(), [])
  end

  @doc """
    Gets the first_name that visited a restaurant_names
    the most number of times

    Returns
    {:ok, %{rows: rows}}

    Where rows is a list of tuples containing:

    [
      {restaurant_name, visitor_name},
      ...
      {restaurant_name, visitor_name}
    ]
  """
  def most_frequent_visitors_per_store do
    Repo.query(Queries.most_frequent_visitor_per_store(), [])
  end

  @doc """
    Gets the first_name that visited the most stores

    Returns
    {:ok, %{rows: rows}}

    Where rows is a list of tuples containing:

    [
      {visitor_name}
    ]
  """
  def most_avid_visitor do
    Repo.query(Queries.most_visited_stores(), [])
  end
end
